const core = require('@actions/core')
const process = require('child_process')
var fs = require('fs')

try {
  if(!fs.existsSync(`${process.env.HOME}/.ssh`)) {
    fs.mkdirSync(`${process.env.HOME}/.ssh`)
  }
  console.log("Building known hosts")
  process.execSync(
    `ssh-keyscan -p ${core.getInput('ssh_port')} ${core.getInput('domain')} >> ${process.env.HOME}/.ssh/known_hosts`,
    {
      timeout: 20000
    }
  )
  console.log("Finished building known hosts!")
  console.log("Starting ssh-agent")
  sshOutput = process.execFileSync(`ssh-agent`, ["-a", core.getInput('ssh_auth_sock')])
  sshOutput.toString().split("\n").forEach((line) => {
    var regexp = /=(.*); /g;
    if (line.includes("SSH_AUTH_SOCK")) {
      const sock = regexp.exec(line)[1];
      core.exportVariable("SSH_AUTH_SOCK", sock)
      console.log(`Agent socket is ${sock}`)
    }
    if (line.includes("SSH_AGENT_PID")) {
      const pid = regexp.exec(line)[1]
      core.exportVariable("SSH_AGENT_PID", pid)
      console.log(`Agent PID is ${pid}`)
    }
  })
  console.log("Started ssh-agent")
  console.log(sshOutput)
} catch (error) {
  console.log(error)
}