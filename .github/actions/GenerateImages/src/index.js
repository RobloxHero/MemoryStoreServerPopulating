const { setFailed, getInput, debug } = require( '@actions/core' );
const { context, getOctokit } = require( '@actions/github' );
import * as d3 from "d3";
const { Resvg } = require('@resvg/resvg-js')
import fs from "fs"
import { JSDOM } from "jsdom"
//
let ListItem = `
<?xml version="1.0" encoding="UTF-8"?>
    <svg id="Background" xmlns="http://www.w3.org/2000/svg" width="323" height="54" viewBox="0 0 323 54">
      <g id="Frame">
        <rect width="323" height="54" rx="9.28" ry="9.28" style="fill: #2c2c3d;"/>
      </g>
    <text transform="translate(8.31 26.44) scale(.97 1)" style="fill: #fff; font-family: BadaBoomProBB, &apos;BadaBoom Pro BB&apos;; font-size: 26.23px;"><tspan x="0" y="0">Title</tspan></text>
  </svg>
  `

function createIssueListPng() {

  fs.writeFileSync('image1.svg', pngBuffer)     
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