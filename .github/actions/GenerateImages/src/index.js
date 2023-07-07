const { setFailed, getInput, debug } = require( '@actions/core' );
const { context, getOctokit } = require( '@actions/github' );

( async function main() {
  try{
    const token = getInput( 'github_token' )
    const octokit = new getOctokit( token );
    const RepoName = context.payload.repository.name
    const owner = context.payload.sender.login
    console.log(context)
    let issues = octokit.rest.issues.listForRepo({
      owner,
      repository,
    });
    console.log(issues)
  }
  catch(e){
    setFailed(e);
  }
} )();