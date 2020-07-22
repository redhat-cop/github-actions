const core = require('@actions/core')
const proc = require('child_process')
const fs = require('fs')

try {
  if(!fs.existsSync(`${process.env['HOME']}/.ssh`)) {
    fs.mkdirSync(`${process.env['HOME']}/.ssh`, {recursive: true})
  }
  console.log("Building known hosts")
  proc.execSync(
    `ssh-keyscan -p ${core.getInput('ssh_port')} ${core.getInput('domain')} >> ${process.env['HOME']}/.ssh/known_hosts`,
    {
      stdio: [null, null, null],
      timeout: 20000
    }
  )
  console.log("Finished building known hosts!")
  console.log("Starting ssh-agent")
  sshOutput = proc.execFileSync(`ssh-agent`, ["-a", core.getInput('ssh_auth_sock')])
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
  console.log("Exported agent variables")
  console.log("Started ssh-agent!")
  console.log("Adding identity")
  proc.execSync(
    "ssh-add -",
    {
      stdio: [null, null, null],
      input: core.getInput("private_key").trim() + "\n"
    }
  )
  console.log("Added identity!")
  console.log("ssh-agent is ready to use")
} catch (error) {
  console.log("Encountered an error:")
  console.log(error.message)
  process.exit(1)
}