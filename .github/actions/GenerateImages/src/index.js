const { setFailed, getInput, debug } = require( '@actions/core' );
const { context, getOctokit } = require( '@actions/github' );

( async function main() {
	debug( '\n Hello!' );
} )();