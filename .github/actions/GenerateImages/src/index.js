const { setFailed, getInput, debug } = require( '@actions/core' );
const { context, getOctokit } = require( '@actions/github' );

( async function main() {
  try{
    const token = getInput( 'github_token' )
    const octokit = new getOctokit( token );
    console.log(context)
    let issues = await octokit.rest.issues.list({owned:false});
    console.log(issues)
  }
  catch(e){
    setFailed(e);
  }
} )();