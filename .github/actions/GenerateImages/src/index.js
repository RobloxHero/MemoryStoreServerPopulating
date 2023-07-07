const { setFailed, getInput, debug } = require( '@actions/core' );
const { context, getOctokit } = require( '@actions/github' );
import * as d3 from "d3";
const { Resvg } = require('@resvg/resvg-js')
import fs from "fs"
import { JSDOM } from "jsdom"

function createSvgDocument() {
  const dom = new JSDOM(`<!DOCTYPE html><body></body>`);
  let body = d3.select(dom.window.document.querySelector("body"))
  body.append("svg")
      .attr("width", "500px")
      .attr("height", "300px")
      .attr("preserveAspectRatio", true)
      .attr('xmlns', 'http://www.w3.org/2000/svg')
      .attr("color", "blue")
      const opts = {
        fitTo: {
          mode: 'width',
          value: 500,
        },
      }
      const resvg = new Resvg(body.html())
      const pngData = resvg.render()
      const pngBuffer = pngData.asPng()
      fs.writeFileSync('image1.png', pngBuffer);
      
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
    createSvgDocument()
    console.log(issues)
  }
  catch(e){
    setFailed(e);
  }
} )();