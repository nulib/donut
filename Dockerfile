FROM ruby:2.4.1

RUN apt-get update -qq
RUN apt-get install -y build-essential libpq-dev nodejs tzdata locales unzip openjdk-7-jre
RUN apt-get install -y libreoffice-core --no-install-recommends
RUN dpkg-reconfigure -f noninteractive tzdata && \
      sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
      echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
      dpkg-reconfigure --frontend=noninteractive locales && \
      update-locale LANG=en_US.UTF-8

# Install prereqs
RUN apt-get install -y libtiff5-dev libjpeg62-turbo-dev libgsf-1-dev libgif-dev libpng-dev
ADD https://s3.amazonaws.com/nul-repo-deploy/donut-vips.deb /tmp/
RUN dpkg -i /tmp/donut-vips.deb

RUN mkdir -p /tmp/ffmpeg && \
      cd /tmp/ffmpeg && \
      curl https://s3.amazonaws.com/nul-repo-deploy/ffmpeg-release-64bit-static.tar.xz | tar xJ && \
      cp `find . -type f -executable` /usr/local/bin/

RUN cd /tmp && \
      curl -O https://s3.amazonaws.com/nul-repo-deploy/fits-1.0.5.zip && \
      cd /usr/local && \
      unzip -o /tmp/fits-1.0.5.zip

# Configuring main directory
RUN useradd -m -U app
USER app
RUN mkdir -p /home/app/current
WORKDIR /home/app/current
# Setting env up
ENV RAILS_ENV='production'
ENV LANG='en_US.UTF-8'
# Adding gems
COPY --chown=app:app Gemfile /home/app/current/
COPY --chown=app:app Gemfile.lock /home/app/current/
RUN bundle install --jobs 20 --retry 5
COPY --chown=app:app . /home/app/current
RUN bundle exec rake assets:precompile RAILS_ENV=production SECRET_KEY_BASE=$(ruby -r 'securerandom' -e 'puts SecureRandom.hex(64)')
RUN rm -rf tmp/* log/*
EXPOSE 3000
CMD bin/boot_container
HEALTHCHECK --start-period=60s CMD curl -f http://localhost:3000/
