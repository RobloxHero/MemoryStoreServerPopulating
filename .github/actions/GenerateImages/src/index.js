const { setFailed, getInput, debug } = require( '@actions/core' );
const { context, getOctokit } = require( '@actions/github' );
import * as d3 from "d3";
const { Resvg } = require('@resvg/resvg-js')
import fs from "fs"
import { JSDOM } from "jsdom"

let ListItem = `
    <svg id="Background" xmlns="http://www.w3.org/2000/svg" width="323" height="54" viewBox="0 0 323 54">
        <rect width="323" height="54" rx="9.28" ry="9.28" style="fill: #2c2c3d;">
            <text color="#ffffff">test</text>
        </rect>
  </svg>
  `

function createIssueListPng() {
  const opts = {
    fitTo: {
      mode: 'width',
      value: 500,
    },
  }
  const resvg = new Resvg(ListItem)
  const pngData = resvg.render()
  const pngBuffer = pngData.asPng()
  fs.writeFileSync('image1.png', pngBuffer)     
}

( async function main() {
  try{
    const token = getInput( 'github_token' )
    const octokit = new getOctokit( token );
    const repo = context.payload.repository.name
    const owner = context.payload.sender.login
    console.log(context)
    let issues = await octokit.rest.issues.listForRepo({
      owner,
      repo,
    });
    createIssueListPng()
    console.log(issues)
  }
  catch(e){
    setFailed(e);
  }
} )();