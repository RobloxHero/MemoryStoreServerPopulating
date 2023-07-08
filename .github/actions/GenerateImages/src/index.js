const { setFailed, getInput, debug } = require( '@actions/core' );
const { context, getOctokit } = require( '@actions/github' );
import fs from "fs"
const { createSVGWindow } = require('svgdom')
import { SVG, extend as SVGextend, Element as SVGElement } from '@svgdotjs/svg.js'

//
let ListItem = `
    <svg id="Background" xmlns="http://www.w3.org/2000/svg" width="323" height="54" viewBox="0 0 323 54">
      <g id="Frame">
        <rect width="323" height="54" rx="9.28" ry="9.28" style="fill: #2c2c3d;"/>
      </g>
    <text transform="translate(8.31 26.44) scale(.97 1)" style="fill: #fff; font-family: BadaBoomProBB, &apos;BadaBoom Pro BB&apos;; font-size: 26.23px;"><tspan x="0" y="0">Title</tspan></text>
  </svg>
  `

function createIssueListPng() {
  const window = createSVGWindow()
  // const svg = SVG().addTo(window)
  // const document = window.document

  // var ListBackground = SVG(document.documentElement).link('http://svgdotjs.github.io/').rect(100, 100)
  console.log(window)
  // console.log(ListBackground.svg())
  // var text = ListBackground.text("Title")
  // text.font({
  //   family:   'BadaBoomProBB', 
  //   size:     '26.23px'
  // })
  // text.fill('#fff').move(20,20)
  // let test = rect.merge(text)
  // fs.writeFileSync('image1.svg', ListBackground.svg())     
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