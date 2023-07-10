const { setFailed, getInput, debug } = require( '@actions/core' );
const { context, getOctokit } = require( '@actions/github' );
import fs from "fs"
const { createSVGWindow } = require('svgdom')
const { SVG, registerWindow, Svg } = require('@svgdotjs/svg.js')
import sharp from 'sharp'

// GitHub Contributers Image - Version 2
// let ImageCoords = {}
// function GetImageCoords(StartingPoint, ImageBox) {
//   if ( ImageCoords.length == 0 ) {
    
//   }
// }

function truncate(count, string) {
  if (string.length < count) {
    return string
  }
 return string.substr(0, count) + '...'
}
function percent(total, number) {
  if (total == 0 || number == 0) {
    return 0
  }
  return number / total
}

function CalcualateDiameter(ImageBoxSP, MaxImageSize, ImagesCount) {
  let ImagesSP = ImageBoxSP / ImagesCount
  if (ImagesSP > MaxImageSize) {
    return MaxImageSize
  } else {
    return ImagesSP
  }
}

function createIssueListPng(issues) {
  const window = createSVGWindow()
  const document = window.document
  registerWindow(window, document)
  const Canvas = SVG(document.documentElement)
  let CanvasHeight = 0
  let CanvasWidth = 323

  let ListItemGroupX = 0
  let ListItemGroupY = 0

  let ListItemHeight = 54
  let ListItemWidth = 323 
  let ListItemTextTranslateX = 8.31
  let ListItemTextTranslateY = 20.11
  let ListItemTextScaleX = 1.14
  let ListItemTextScaleY = 1
  let CornerRadius = 9.28
  let ListItemTopPadding = 5

  let CommentTextTranslateX = 302.56
  let CommentTextTranslateY = 44.92
  let CommentTextScaleX = 1.04
  let CommentTextScaleY = 1
 
  let TodoTextTranslateX = 15.73
  let TodoTextTranslateY = 43.63
  let TodoTextScaleX = 1.29
  let TodoTextScaleY = 1
  
  let WorkingOnItTextTranslateX = 15.73
  let WorkingOnItTextTranslateY = 43.63
  let WorkingOnItTextScaleX = 1.29
  let WorkingOnItTextScaleY = 1

  let ListItem = SVG(`<rect width="${ListItemWidth}" height="${ListItemHeight}" rx="${CornerRadius}" ry="${CornerRadius}" style="fill: #2c2c3d;"/>`)
  let ListItemTitle = SVG(`<text style="fill: #fff; font-family: AdriannaCondensed-ExtraBold, &apos;Adrianna Condensed&apos;; font-size: 18.78px; font-weight: 700;"></text>`)
  let CommentIcon = SVG(`<g id="_-Product-Icons" data-name="🔍-Product-Icons">
  <g id="ic_fluent_comment_24_regular" data-name="ic fluent comment 24 regular">
    <path id="_-Color" data-name="🎨-Color" d="m284.23,45.42c-1.23,0-2.23-.99-2.23-2.22v-5.98c0-1.22,1-2.22,2.23-2.22h9.53c1.23,0,2.23.99,2.23,2.22v5.98c0,1.22-1,2.22-2.23,2.22h-4.54l-3.29,2.56c-.36.28-.88.2-1.15-.17-.11-.15-.16-.33-.16-.51v-1.88h-.39Zm4.56-.87h5.13c.66,0,1.2-.53,1.2-1.19v-5.42c0-.66-.54-1.19-1.2-1.19h-9.84c-.66,0-1.2.53-1.2,1.19v5.42c0,.66.54,1.19,1.2,1.19h1.42v.49s0,1.95,0,1.95l3.29-2.44Z" style="fill: #7788b2;"/>
  </g>
</g>`)
  let CommentText = SVG(`<text style="fill: #7788b2; font-family: AdriannaCondensed-ExtraBold, &apos;Adrianna Condensed&apos;; font-size: 12.85px; font-weight: 700;"></text>`)
  let TodoRect = SVG(`<rect x="9" y="30" width="46" height="18" rx="6.2" ry="6.2" style="fill: #ff7bac;"/>`)
  let TodoText = SVG(`<text style="fill: #2c2c3d; font-family: Roboto-Black, Roboto; font-size: 12.43px; font-weight: 800;"><tspan x="0" y="0" style="letter-spacing: -.01em;">t</tspan><tspan x="4.08" y="0">odo</tspan></text>`)
  let WorkingOnItRect = SVG(`<rect x="9" y="30" width="109" height="18" rx="6.2" ry="6.2" style="fill: #9cbc6f;"/>`)
  let WorkingOnItText = SVG('<text style="fill: #2c2c3d; font-family: Roboto-Black, Roboto; font-size: 12.43px; font-weight: 800;"><tspan x="0" y="0">working on it</tspan></text>')
  
  for (let i=0; i<issues.length; i++ ) {
    // Adjust image height as a list item is added
    CanvasHeight += ListItemHeight + ListItemTopPadding
    Canvas.size(CanvasWidth, CanvasHeight)

    // Copy the list group svg and move into place
    let ListItemGroup = SVG().link('https://github.com/RobloxHero/MemoryStoreServerPopulating/issues/'+issues[i].number)
    ListItemGroupY = (ListItemHeight + ListItemTopPadding) * i
    ListItemGroup.addTo(Canvas)

    // Copy the list background and add to list group
    let ListItemClone = ListItem.clone()
    ListItemClone.addTo(ListItemGroup)
    ListItemGroup.move(ListItemGroupX, ListItemGroupY)

    // Copy the title and add to list group
    let ListItemTitleClone = ListItemTitle.clone()
    ListItemTitleClone.transform({ translateX: ListItemTextTranslateX, translateY: ListItemTextTranslateY + ListItemGroupY, scaleX: ListItemTextScaleX, scaleY: ListItemTextScaleY })
    ListItemTitleClone.text(truncate(27, issues[i].title))
    ListItemTitleClone.addTo(ListItemGroup).front()

    // Copy the comment icon and add to list group
    let CommentIconClone = CommentIcon.clone()
    CommentIconClone.transform({ translateY: ListItemGroupY })
    CommentIconClone.addTo(ListItemGroup).front()

    // Copy the comment count text and add to list group
    let CommentTextClone = CommentText.clone()
    CommentTextClone.text(issues[i].comments)
    CommentTextClone.transform({ translateX: CommentTextTranslateX, translateY: CommentTextTranslateY + ListItemGroupY, scaleX: CommentTextScaleX, scaleY: CommentTextScaleY })
    CommentTextClone.addTo(ListItemGroup).front()

    if (issues[i].assignee != null) {
      let WorkingOnItRectClone = WorkingOnItRect.clone()
      WorkingOnItRectClone.transform({ translateY: ListItemGroupY })
      WorkingOnItRectClone.addTo(ListItemGroup).front()
      let WorkingOnItTextClone = WorkingOnItText.clone()
      WorkingOnItTextClone.transform({ translateX: WorkingOnItTextTranslateX, translateY: WorkingOnItTextTranslateY + ListItemGroupY, scaleX: WorkingOnItTextScaleX, scaleY: WorkingOnItTextScaleY })
      WorkingOnItTextClone.addTo(ListItemGroup).front()
    } else {
      let TodoRectClone = TodoRect.clone()
      TodoRectClone.transform({ translateY: ListItemGroupY })
      TodoRectClone.addTo(ListItemGroup).front()
      let TodoTextClone = TodoText.clone()
      TodoTextClone.transform({ translateX: TodoTextTranslateX, translateY: TodoTextTranslateY + ListItemGroupY, scaleX: TodoTextScaleX, scaleY: TodoTextScaleY  })
      TodoTextClone.addTo(ListItemGroup).front()
    }   
  }
  // Export to SVG
  fs.writeFileSync('GitHub-Images/IssuesList.svg', Canvas.svg())  

  // Export to PNG

}

function createProfile(milestones, repo, issues) {
  const window = createSVGWindow()
  const document = window.document
  registerWindow(window, document)
  const Canvas = SVG(document.documentElement).size(690, 490)
  const ProfileGroup = SVG().link('https://github.com/RobloxHero/MemoryStoreServerPopulating')
  ProfileGroup.addTo(Canvas)
  let ProfileBackground = SVG(`<svg width="690" height="555" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 690 555">
  <defs>
    <radialGradient id="radial-gradient" cx="136.68" cy="337.94" fx="136.68" fy="337.94" r="21.97" gradientUnits="userSpaceOnUse">
      <stop offset="0" stop-color="#ee9bff"/>
      <stop offset="1" stop-color="#7200d2"/>
    </radialGradient>
    <radialGradient id="radial-gradient-2" cx="518.52" cy="375.01" fx="518.52" fy="375.01" r="24.57" xlink:href="#radial-gradient"/>
    <radialGradient id="radial-gradient-3" cx="183.8" cy="399.83" fx="183.8" fy="399.83" r="19.73" xlink:href="#radial-gradient"/>
    <radialGradient id="radial-gradient-4" cx="308.01" cy="330.26" fx="308.01" fy="330.26" r="16.88" xlink:href="#radial-gradient"/>
    <radialGradient id="radial-gradient-5" cx="411.26" cy="359.84" fx="411.26" fy="359.84" r="13.7" xlink:href="#radial-gradient"/>
    <radialGradient id="radial-gradient-6" cx="572.48" cy="413.07" fx="572.48" fy="413.07" r="15.52" xlink:href="#radial-gradient"/>
    <radialGradient id="radial-gradient-7" cx="623.19" cy="358.21" fx="623.19" fy="358.21" r="19.2" xlink:href="#radial-gradient"/>
    <radialGradient id="radial-gradient-8" cx="61.94" cy="392.67" fx="61.94" fy="392.67" r="16.82" xlink:href="#radial-gradient"/>
  </defs>
  <rect x="4" width="686" height="487" rx="8.84" ry="8.84" style="fill: #2c2c3d;"/>
  <path id="GithubLogo" d="m43.45,14.83c9.96,0,18.03,8.07,18.03,18.03,0,7.75-4.94,14.63-12.28,17.1-.9.18-1.24-.38-1.24-.86,0-.61.02-2.55.02-4.96,0-1.69-.56-2.77-1.22-3.34,4.01-.45,8.23-1.98,8.23-8.9,0-1.98-.7-3.58-1.85-4.85.18-.45.81-2.3-.18-4.78,0,0-1.51-.5-4.96,1.85-1.44-.41-2.97-.61-4.51-.61s-3.06.2-4.51.61c-3.45-2.32-4.96-1.85-4.96-1.85-.99,2.48-.36,4.33-.18,4.78-1.15,1.26-1.85,2.88-1.85,4.85,0,6.9,4.19,8.45,8.2,8.9-.52.45-.99,1.24-1.15,2.41-1.04.47-3.63,1.24-5.25-1.49-.34-.54-1.35-1.87-2.77-1.85-1.51.02-.61.86.02,1.19.77.43,1.65,2.03,1.85,2.55.36,1.01,1.53,2.95,6.06,2.12,0,1.51.02,2.93.02,3.36,0,.47-.34,1.01-1.24.86-7.36-2.45-12.33-9.34-12.33-17.1,0-9.96,8.07-18.03,18.03-18.03Z" style="fill: #fff;"/>
  <path d="m600.63,22.43l2.41,7.84c.09.3.36.5.65.5h7.8c.66,0,.94.9.4,1.31l-6.31,4.84c-.24.18-.34.51-.25.81l2.41,7.84c.21.67-.52,1.22-1.06.81l-6.31-4.84c-.24-.18-.57-.18-.81,0l-6.31,4.84c-.54.41-1.26-.14-1.06-.81l2.41-7.84c.09-.3,0-.63-.25-.81l-6.31-4.84c-.54-.41-.26-1.31.4-1.31h7.8c.3,0,.56-.2.65-.5l2.41-7.84c.21-.67,1.1-.67,1.31,0Z" style="fill: #fffe2e;"/>
  <g id="Stars">
    <polygon points="158.56 348.17 143.03 347.56 133.73 360 129.51 345.05 114.8 340.05 127.72 331.42 127.93 315.88 140.13 325.5 154.97 320.9 149.6 335.48 158.56 348.17" style="fill: url(#radial-gradient);"/>
    <polygon points="520.81 399.46 511.21 384.97 493.83 384.67 504.64 371.06 499.57 354.44 515.85 360.52 530.08 350.55 529.33 367.92 543.21 378.38 526.47 383.03 520.81 399.46" style="fill: url(#radial-gradient-2);"/>
    <polygon points="203.44 409.08 189.5 408.49 181.11 419.65 177.36 406.21 164.16 401.68 175.78 393.96 176.01 380.01 186.94 388.68 200.28 384.58 195.42 397.66 203.44 409.08" style="fill: url(#radial-gradient-3);"/>
    <polygon points="323.65 341.76 311.92 339.21 303.17 347.44 301.96 335.49 291.43 329.71 302.42 324.87 304.67 313.07 312.67 322.03 324.58 320.52 318.53 330.89 323.65 341.76" style="fill: url(#radial-gradient-4);"/>
    <polygon points="415.02 373.81 407.97 367.06 398.41 369.04 402.66 360.25 397.82 351.77 407.49 353.09 414.06 345.88 415.79 355.48 424.69 359.5 416.09 364.11 415.02 373.81" style="fill: url(#radial-gradient-5);"/>
    <polygon points="588.13 418.69 577.15 419.15 571.31 428.46 567.48 418.16 556.83 415.48 565.44 408.65 564.7 397.69 573.85 403.77 584.04 399.68 581.09 410.26 588.13 418.69" style="fill: url(#radial-gradient-6);"/>
    <polygon points="634.61 377.02 622.69 370.3 610.4 376.3 613.11 362.89 603.6 353.05 617.19 351.49 623.61 339.41 629.3 351.85 642.77 354.22 632.7 363.47 634.61 377.02" style="fill: url(#radial-gradient-7);"/>
    <polygon points="78.41 402.67 66.54 400.99 58.44 409.82 56.36 398.02 45.46 393.04 56.04 387.42 57.41 375.51 66.03 383.84 77.78 381.46 72.52 392.23 78.41 402.67" style="fill: url(#radial-gradient-8);"/>
  </g>
  <text transform="translate(15.97 97.03) scale(.97 1)" style="fill: #c7b299; font-family: Roboto-Black, Roboto; font-size: 19.52px; font-weight: 800;">Top 3 Milestones</text>
</svg>`)
ProfileBackground.addTo(ProfileGroup).first()
let ListItem = SVG(`<g id="MilestoneList">
<rect id="ListBackground" x="9" y="107" width="229" height="64" rx="8.94" ry="8.94" style="opacity: .28;"/>
<text id="Title" transform="translate(16.42 124.68) scale(1.14 1)" style="fill: #fff; font-family: AdriannaCondensed-ExtraBold, &apos;Adrianna Condensed&apos;; font-size: 14.28px; font-weight: 700;">Test</text>
<g id="ProgressBar">
  <rect id="ProgressBarIcon" x="19" y="158" width="0" height="6" style="fill: #39b54a;" rx="2" ry="2"/>
  </g>
<text id="CompleteLabel" transform="translate(153.36 149) scale(.97 1)" style="fill: #fff; font-family: Roboto-Black, Roboto; font-size: 10.92px; font-weight: 800;">100% Complete</text>
<text id="IssuesCountLabel" transform="translate(17.79 149) scale(.97 1)" style="fill: #fff; font-family: Roboto-Black, Roboto; font-size: 10.92px; font-weight: 800;"> 1 open 2 closed</text>
</g>`)
let VersionProgress = SVG(`<g id="VersionProgress">
<g id="ProgressBar" width="686" height="487">
  <rect x="26" y="447" width="646" height="30" rx="8.84" ry="8.84" style="fill: #527f55; opacity: .42;"/>
  <rect x="26" y="447" id="ProgressBarVersion" width="400" height="30" rx="8.84" ry="8.84" style="fill: #39b54a;"/>
</g>
<text id="VersionLabel" text-anchor="middle" x="45%" transform="translate(0 412.59) scale(1.14 1)" style="fill: #fffe2e; font-family: AdriannaCondensed-ExtraBold, &apos;Adrianna Condensed&apos;; font-size: 35.04px; font-weight: 700;">Version 1</text>
</g>`)
let RepoTitle = SVG(`<text transform="translate(82.71 41.94) scale(1.14 1)" style="fill: #fff; font-family: AdriannaCondensed-ExtraBold, &apos;Adrianna Condensed&apos;; font-size: 21.93px; font-weight: 700;">Test</text>`)
RepoTitle.text(repo.name)
RepoTitle.addTo(ProfileGroup).first()
let StarsLabel = SVG(`<text transform="translate(621.88 46.34) scale(1.11 1)" style="fill: #fff; font-family: AdriannaCondensed-ExtraBold, &apos;Adrianna Condensed&apos;; font-size: 31.76px; font-weight: 700;"><tspan x="0" y="0">45</tspan></text>`)
StarsLabel.text(repo.stargazers_count)
StarsLabel.addTo(ProfileGroup).first()

let ListHeight = 64
let ListPadding = 5
let ProgressBarWidth = 209
let count = 0
for(let i=0; i<milestones.length; i++) {
  if (!milestones[i].title.includes("Version")) {
    if (count < 3) {
      console.log(milestones[i].title)
      let TotalIssues = parseInt(milestones[i].closed_issues) + parseInt(milestones[i].open_issues)
      let IssuesCompleted = parseInt(milestones[i].closed_issues)
      ListItem.findOne('#Title').text(milestones[i].title)
      ListItem.findOne('#ProgressBarIcon').width( percent(TotalIssues, IssuesCompleted)  *  ProgressBarWidth)
      ListItem.findOne('#CompleteLabel').text( (percent(TotalIssues, IssuesCompleted) * 100) + "% completed")
      ListItem.findOne('#IssuesCountLabel').text(milestones[i].open_issues + " open "+ milestones[i].closed_issues+" closed")
      let ListItemClone = ListItem.clone()
      ListItemClone.move(0, ((ListHeight + ListPadding) * count))
      ListItemClone.addTo(ProfileGroup).first()
    }
    count++
  } else {
    let VersionIssuesOpen = 0
    let VersionIssuesClosed = 0
    let VersionIssues = issues.filter((issue) => {
        let VersionLabel = issue.labels.find((label) => {
          if (label.name == milestones[i].title) {
            if(issue.state == 'open') {
              VersionIssuesOpen++
            }
            if (issue.state == 'closed') {
              VersionIssuesClosed++
            }
            return true
          }
        })
        if( VersionLabel != null && VersionLabel.length > 0) {
          return true
        }
    })
    VersionProgress.findOne('#ProgressBarVersion').width( percent(VersionIssuesClosed, VersionIssues.length)  *  646)
    VersionProgress.findOne('#VersionLabel').text(milestones[i].title)
    VersionProgress.addTo(ProfileGroup).first()
  }
}

fs.writeFileSync('GitHub-Images/Profile.svg', Canvas.svg())
}

// Github Contributer Images - Version 2
function GithubContributerImage() {
  let ImageBox = SVG('rect').size(300,400).move(300,70)
  let ImageBoxSP = ImageBox.height() * ImageBox.width()
  let MaxImageSize = 60
  for (let i=0; i<collaborators.length; i++) {
    let StartingPointX = Math.random(ImageBox.width())
    let StartingPointY = Math.random(ImageBox.height())
    let ImageDiameter = CalcualateDiameter(ImageBoxSP, MaxImageSize, collaborators.length)
    let GetInageCoords = GetImageCoords({x:StartingPointX, y:StartingPointY}, {height:ImageBox.height(), width:ImageBox.width()})
    let Image = SVG().image(collaborators[i].avatar_url).size(ImageDiameter, ImageDiameter)
    Image.addTo(ImageBox)
  }
  ImageBox.addTo(ProfileGroup)
}

( async function main() {
  try{
    const token = getInput( 'github_token' )
    const octokit = new getOctokit( token )
    const repo = context.payload.repository.name
    const owner = context.payload.sender.login
    // console.log(context)
    let issues = await octokit.rest.issues.listForRepo({
      owner,
      repo,
    })
    let milestones = await octokit.rest.issues.listMilestones({
      owner,
      repo,
    });
    let collaborators = octokit.rest.repos.listCollaborators({
      owner,
      repo,
    });
    createIssueListPng(issues.data)
    createProfile(milestones.data, context.payload.repository, issues.data)
  }
  catch(e){
    setFailed(e);
  }
} )()