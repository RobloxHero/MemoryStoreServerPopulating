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

function createIssueListPng(issues) {
  const canvas = SVG(document.documentElement).size(323, 500)
  let link = 'https://google.com'
  let movex = 0
  let yMove = 0
  let yCanvasHeight = 0
  let yHeight = 54
  let yPadding = 5
  let ListItemGroup = SVG().group().link(link).addTo(canvas)
  let ListItem = SVG('<rect width="323" height="54" rx="9.28" ry="9.28" style="fill: #2c2c3d;"/>')
  let Title = 'Testing the label for the Issues'
  let text = SVG(`<text transform="translate(8.31 20.11) scale(1.14 1)" style="fill: #fff; font-family: AdriannaCondensed-ExtraBold, &apos;Adrianna Condensed&apos;; font-size: 18.78px; font-weight: 700;">${Title}</text>`)
  let commentIcon = SVG(`<g id="_-Product-Icons" data-name="🔍-Product-Icons">
  <g id="ic_fluent_comment_24_regular" data-name="ic fluent comment 24 regular">
    <path id="_-Color" data-name="🎨-Color" d="m284.23,45.42c-1.23,0-2.23-.99-2.23-2.22v-5.98c0-1.22,1-2.22,2.23-2.22h9.53c1.23,0,2.23.99,2.23,2.22v5.98c0,1.22-1,2.22-2.23,2.22h-4.54l-3.29,2.56c-.36.28-.88.2-1.15-.17-.11-.15-.16-.33-.16-.51v-1.88h-.39Zm4.56-.87h5.13c.66,0,1.2-.53,1.2-1.19v-5.42c0-.66-.54-1.19-1.2-1.19h-9.84c-.66,0-1.2.53-1.2,1.19v5.42c0,.66.54,1.19,1.2,1.19h1.42v.49s0,1.95,0,1.95l3.29-2.44Z" style="fill: #7788b2;"/>
  </g>
</g>`)
let commentNumber = 12
  let commentCount = SVG(`<text transform="translate(302.56 44.92) scale(1.04 1)" style="fill: #7788b2; font-family: AdriannaCondensed-ExtraBold, &apos;Adrianna Condensed&apos;; font-size: 12.85px; font-weight: 700;"><tspan x="0" y="0">${commentNumber}</tspan></text>`)
  let todoRect = SVG(`<rect x="9" y="30" width="46" height="18" rx="6.2" ry="6.2" style="fill: #ff7bac;"/>`)
  let todoText = SVG(`<text transform="translate(15.73 43.63) scale(1.29 1)" style="fill: #2c2c3d; font-family: Roboto-Black, Roboto; font-size: 12.43px; font-weight: 800;"><tspan x="0" y="0" style="letter-spacing: -.01em;">t</tspan><tspan x="4.08" y="0">odo</tspan></text>`)
  let WorkingOnItRect = SVG(`<rect x="9" y="30" width="109" height="18" rx="6.2" ry="6.2" style="fill: #9cbc6f;"/>`)
  let WorkingOnItText = SVG('<text transform="translate(15.73 43.63) scale(1.29 1)" style="fill: #2c2c3d; font-family: Roboto-Black, Roboto; font-size: 12.43px; font-weight: 800;"><tspan x="0" y="0">working on it</tspan></text>')
  
  commentIcon.addTo(ListItemGroup)
  text.addTo(ListItemGroup)
  commentCount.addTo(ListItemGroup)
  console.log(canvas.svg())
  for (let i=0; i<issues.length; i++ ) {
    let ListItemClone = ListItem.clone()
    ListItemClone.addTo(ListItemGroup)
    Title = issues[i].title
    link = issues[i].url
    commentNumber = issues[i].comments
    if (issues[i].assignee != null) {
      WorkingOnItRect.addTo(ListItemGroup)
      WorkingOnItText.addTo(ListItemGroup)
    } else {
      todoRect.addTo(ListItemGroup)
      todoText.addTo(ListItemGroup)
    }
    if (i > 0) {
      yMove = yHeight + yPadding * i
      yCanvasHeight += yMove
      ListItemGroup.move(movex, yMove)
      canvas.size(323, yCanvasHeight)
    }
  }
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
    createIssueListPng(issues.data)
    console.log(issues.data)
  }
  catch(e){
    setFailed(e);
  }
} )();