const { setFailed, getInput, debug } = require( '@actions/core' );
const { context, getOctokit } = require( '@actions/github' );
import * as d3 from "d3";
import * as sharp from "sharp"
import fs from "fs"
import { JSDOM } from "jsdom"

function createSvgDocument() {
  const dom = new JSDOM(`<!DOCTYPE html><body></body>`);
  const background = d3.create("svg")
      .attr("width", "500px")
      .attr("height", "300px")
      .attr("preserveAspectRatio", true)
      .attr('xmlns', 'http://www.w3.org/2000/svg')
      .attr("backgroundColor", "blue")
  let body = d3.select(dom.window.document.querySelector("body"))
      .append(background)
      // fs.writeFileSync('image1.svg', background);
      // background.append(text)
      sharp(body)
      .png()
      .toFile("image1.png")
      .then(function(info) {
        console.log(info)
      })
      .catch(function(err) {
        console.log(err)
      })
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