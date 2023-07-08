const { setFailed, getInput, debug } = require( '@actions/core' );
const { context, getOctokit } = require( '@actions/github' );
import fs from "fs"
const { createSVGWindow } = require('svgdom')
const window = createSVGWindow()
const document = window.document
const { SVG, registerWindow } = require('@svgdotjs/svg.js')
registerWindow(window, document)
//
let ListItem = `
    

  `

function createIssueListPng() {
  const canvas = SVG(document.documentElement)
  let ListBackground = SVG('<svg xmlns="http://www.w3.org/2000/svg" width="323" height="500" viewBox="0 0 323 54"/>')
  let ListItem = SVG('<rect width="323" height="54" rx="9.28" ry="9.28" style="fill: #2c2c3d;"/>').addTo(ListBackground)
  let Title = 'Testing the label for the reviews'
  var text = SVG('<text>hello</text>').addTo(ListItem)
  text.fill('#fff')
  fs.writeFileSync('image1.svg', ListBackground.svg())     
}

( async function main() {
  try{
    const token = getInput( 'github_token' )
    const octokit = new getOctokit( token );
    const repo = context.payload.repository.name
    const owner = context.payload.sender.login
    // console.log(context)
    let issues = await octokit.rest.issues.listForRepo({
      owner,
      repo,
    });
    createIssueListPng()
    // console.log(issues)
  }
  catch(e){
    setFailed(e);
  }
} )();