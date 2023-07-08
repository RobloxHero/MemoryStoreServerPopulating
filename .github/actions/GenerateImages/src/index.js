const { setFailed, getInput, debug } = require( '@actions/core' );
const { context, getOctokit } = require( '@actions/github' );
import fs from "fs"
const { createSVGWindow } = require('svgdom')
const window = createSVGWindow()
const document = window.document
const { SVG, registerWindow, Svg } = require('@svgdotjs/svg.js')
registerWindow(window, document)
//
let ListItem = `
<text transform="translate(8.31 26.44) scale(.97 1)" style="fill: #fff; font-family: AdriannaCondensed-ExtraBold, &apos;Adrianna Condensed&apos;; font-size: 26.23px; font-weight: 700;"><tspan x="0" y="0" style="letter-spacing: -.02em;">T</tspan><tspan x="14.79" y="0">itle</tspan></text>

  `

function createIssueListPng() {
  const canvas = SVG(document.documentElement).size(323, 500)
  let ListItemGroup = SVG().group().addTo(canvas)
  let ListItem = SVG('<rect width="323" height="54" rx="9.28" ry="9.28" style="fill: #2c2c3d;"/>').addTo(ListItemGroup)
  let Title = 'Testing the label for the Issues'
  var text = SVG(`<text transform="translate(8.31 20.11) scale(1.14 1)" style="fill: #fff; font-family: AdriannaCondensed-ExtraBold, &apos;Adrianna Condensed&apos;; font-size: 18.78px; font-weight: 700;">${Title}</text>`)
  text.addTo(ListItemGroup)
  console.log(canvas.svg())
  fs.writeFileSync('image1.svg', canvas.svg())     
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
    console.log(issues)
  }
  catch(e){
    setFailed(e);
  }
} )();