const { setFailed, getInput, debug } = require( '@actions/core' );
const { context, getOctokit } = require( '@actions/github' );
import * as d3 from "d3";
import * as sharp from "sharp"

function createSvgDocument() {

  const background = d3.create("svg")
      .attr("width", "500px")
      .attr("height", "300px")
      .attr("preserveAspectRatio", true)
      .attr("backgroundColor", "blue")
  const text = d3.create("p")
      .text("hello")
      background.append(text)
      sharp(background)
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
    let NumberOfIssuesNotFinished = issues.Map((issue) => {
      // Look for the labels
    })
    console.log(issues)
  }
  catch(e){
    setFailed(e);
  }
} )();