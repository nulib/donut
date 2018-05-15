#################################
# Build the support container
FROM ruby:2.4.2 as base
LABEL edu.northwestern.library.app=DONUT \
      edu.northwestern.library.role=support

ENV BUILD_DEPS="build-essential libpq-dev tzdata locales unzip" \
    DEBIAN_FRONTEND="noninteractive" \
    RAILS_ENV="production" \
    LANG="en_US.UTF-8" \
    FITS_VERSION="1.0.5"

ADD https://s3.amazonaws.com/nul-repo-deploy/ffmpeg-release-64bit-static.tar.xz /tmp
ADD https://s3.amazonaws.com/nul-repo-deploy/fits-${FITS_VERSION}.zip /tmp

RUN useradd -m -U app && \
    su -s /bin/bash -c "mkdir -p /home/app/current" app

RUN apt-get update -qq && \
    apt-get install -y $BUILD_DEPS --no-install-recommends

RUN \
    # Set locale
    dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    \
    mkdir -p /tmp/stage/bin && \
    \
    # Install FFMPEG
    mkdir -p /tmp/ffmpeg && \
    cd /tmp/ffmpeg && \
    tar xJf /tmp/ffmpeg-release-64bit-static.tar.xz && \
    cp `find . -type f -executable` /tmp/stage/bin/ && \
    \
    # Install FITS
    cd /tmp/stage && \
    unzip -o /tmp/fits-${FITS_VERSION}.zip

USER app
WORKDIR /home/app/current

COPY --chown=app:app Gemfile /home/app/current/
COPY --chown=app:app Gemfile.lock /home/app/current/

RUN bundle install --jobs 20 --retry 5 --with aws:postgres --without development:test --path vendor/gems && \
    rm -rf vendor/gems/ruby/*/cache/* vendor/gems/ruby/*/bundler/gems/*/.git

#################################
# Build the Application container
FROM ruby:2.4.2 as app
LABEL edu.northwestern.library.app=DONUT \
      edu.northwestern.library.role=app


RUN useradd -m -U app && \
    su -s /bin/bash -c "mkdir -p /home/app/current/vendor/gems" app

ENV RUNTIME_DEPS="libpq5 libtiff5 libjpeg62-turbo libgsf-1-dev libgif-dev libpng3 tzdata locales nodejs openjdk-7-jre libreoffice-core yarn" \
    DEBIAN_FRONTEND="noninteractive" \
    RAILS_ENV="production" \
    LANG="en_US.UTF-8" \
    FITS_VERSION="1.0.5"


RUN \
    # Install NodeJS and Yarn package repos
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    # Install runtime dependencies
    apt-get update -qq && \
    apt-get install -y $RUNTIME_DEPS --no-install-recommends && \
    # Clean up package cruft
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    # Install webpack
    alias nodejs=node && \
    yarn add webpack

RUN \
    # Set locale
    dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

# Install VIPS
RUN cd /tmp && \
    curl -O https://s3.amazonaws.com/nul-repo-deploy/donut-vips.deb && \
    dpkg -i /tmp/donut-vips.deb && \
    rm /tmp/donut-vips.deb

COPY --from=base /tmp/stage/bin/* /usr/local/bin/
COPY --from=base /tmp/stage/fits-${FITS_VERSION} /usr/local/fits
COPY --chown=app:staff --from=base /usr/local/bundle /usr/local/bundle
COPY --chown=app:app --from=base /home/app/current/vendor/gems/ /home/app/current/vendor/gems/
COPY --chown=app:app . /home/app/current/

RUN mkdir /var/log/puma && \
    chown root:app /var/log/puma && \
    chmod 0775 /var/log/puma

RUN mkdir /var/run/puma && \
    chown root:app /var/run/puma && \
    chmod 0775 /var/run/puma

USER app
WORKDIR /home/app/current
RUN bundle exec rake assets:precompile SECRET_KEY_BASE=$(ruby -r 'securerandom' -e 'puts SecureRandom.hex(64)')

EXPOSE 3000
CMD bin/boot_container
HEALTHCHECK --start-period=60s CMD curl -f http://localhost:3000/
