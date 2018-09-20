node {
  def tag_name = env.BRANCH_NAME.split('/').last()
  if ( tag_name == "master" ) {
    tag_name = "production"
  }
  checkout scm
  sh "docker build -t nulib/donut:${tag_name} ."
  docker.withRegistry('', 'docker-hub-credentials') {
    docker.image("nulib/donut:${tag_name}").push()
  }
  sh "docker tag \$(docker image ls -q --filter 'label=edu.northwestern.library.role=support' --filter 'label=edu.northwestern.library.app=DONUT' | head -1) nulib/donut-build:${tag_name}"
  sh "docker image prune -f"
  sh "docker run -t -v /home/ec2-user/.aws:/root/.aws nulib/ebdeploy ${tag_name} donut"

  withCredentials([string(credentialsId: 'honeybadger-donut', variable: 'api_key')]) {
    def repo = sh(script: "git remote get-url origin", returnStdout: true).trim()
    def sha = sh(script: "git log -n 1 --pretty=format:'%h'", returnStdout: true).trim()
    httpRequest "https://api.honeybadger.io/v1/deploys?api_key=${api_key}&deploy[environment]=${tag_name}&deploy[repository]=${repo}&deploy[local_username]=jenkins&deploy[revision]=${sha}"
  }
}
