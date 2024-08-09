"use strict";(self.webpackChunkmythic_phone=self.webpackChunkmythic_phone||[]).push([[9484],{69484:(r,e,a)=>{a.d(e,{A:()=>N});var t=a(86887),o=a(64180),n=a(55429),i=a(1551),s=a(50035),l=a(10519),u=a(74274),c=a(69921),d=a(90354),f=a(94526),b=a(88594),m=a(35457);function h(r){return(0,m.A)("MuiLinearProgress",r)}(0,a(40725).A)("MuiLinearProgress",["root","colorPrimary","colorSecondary","determinate","indeterminate","buffer","query","dashed","dashedColorPrimary","dashedColorSecondary","bar","barColorPrimary","barColorSecondary","bar1Indeterminate","bar1Determinate","bar1Buffer","bar2Indeterminate","bar2Buffer"]);var p=a(64922);const v=["className","color","value","valueBuffer","variant"];let g,A,y,w,C,k,S=r=>r;const $=(0,l.i7)(g||(g=S`
  0% {
    left: -35%;
    right: 100%;
  }

  60% {
    left: 100%;
    right: -90%;
  }

  100% {
    left: 100%;
    right: -90%;
  }
`)),x=(0,l.i7)(A||(A=S`
  0% {
    left: -200%;
    right: 100%;
  }

  60% {
    left: 107%;
    right: -8%;
  }

  100% {
    left: 107%;
    right: -8%;
  }
`)),P=(0,l.i7)(y||(y=S`
  0% {
    opacity: 1;
    background-position: 0 -23px;
  }

  60% {
    opacity: 0;
    background-position: 0 -23px;
  }

  100% {
    opacity: 1;
    background-position: -200px -23px;
  }
`)),B=(r,e)=>"inherit"===e?"currentColor":"light"===r.palette.mode?(0,u.a)(r.palette[e].main,.62):(0,u.e$)(r.palette[e].main,.5),I=(0,f.Ay)("span",{name:"MuiLinearProgress",slot:"Root",overridesResolver:(r,e)=>{const{ownerState:a}=r;return[e.root,e[`color${(0,c.A)(a.color)}`],e[a.variant]]}})((({ownerState:r,theme:e})=>(0,o.A)({position:"relative",overflow:"hidden",display:"block",height:4,zIndex:0,"@media print":{colorAdjust:"exact"},backgroundColor:B(e,r.color)},"inherit"===r.color&&"buffer"!==r.variant&&{backgroundColor:"none","&::before":{content:'""',position:"absolute",left:0,top:0,right:0,bottom:0,backgroundColor:"currentColor",opacity:.3}},"buffer"===r.variant&&{backgroundColor:"transparent"},"query"===r.variant&&{transform:"rotate(180deg)"}))),q=(0,f.Ay)("span",{name:"MuiLinearProgress",slot:"Dashed",overridesResolver:(r,e)=>{const{ownerState:a}=r;return[e.dashed,e[`dashedColor${(0,c.A)(a.color)}`]]}})((({ownerState:r,theme:e})=>{const a=B(e,r.color);return(0,o.A)({position:"absolute",marginTop:0,height:"100%",width:"100%"},"inherit"===r.color&&{opacity:.3},{backgroundImage:`radial-gradient(${a} 0%, ${a} 16%, transparent 42%)`,backgroundSize:"10px 10px",backgroundPosition:"0 -23px"})}),(0,l.AH)(w||(w=S`
    animation: ${0} 3s infinite linear;
  `),P)),M=(0,f.Ay)("span",{name:"MuiLinearProgress",slot:"Bar1",overridesResolver:(r,e)=>{const{ownerState:a}=r;return[e.bar,e[`barColor${(0,c.A)(a.color)}`],("indeterminate"===a.variant||"query"===a.variant)&&e.bar1Indeterminate,"determinate"===a.variant&&e.bar1Determinate,"buffer"===a.variant&&e.bar1Buffer]}})((({ownerState:r,theme:e})=>(0,o.A)({width:"100%",position:"absolute",left:0,bottom:0,top:0,transition:"transform 0.2s linear",transformOrigin:"left",backgroundColor:"inherit"===r.color?"currentColor":e.palette[r.color].main},"determinate"===r.variant&&{transition:"transform .4s linear"},"buffer"===r.variant&&{zIndex:1,transition:"transform .4s linear"})),(({ownerState:r})=>("indeterminate"===r.variant||"query"===r.variant)&&(0,l.AH)(C||(C=S`
      width: auto;
      animation: ${0} 2.1s cubic-bezier(0.65, 0.815, 0.735, 0.395) infinite;
    `),$))),L=(0,f.Ay)("span",{name:"MuiLinearProgress",slot:"Bar2",overridesResolver:(r,e)=>{const{ownerState:a}=r;return[e.bar,e[`barColor${(0,c.A)(a.color)}`],("indeterminate"===a.variant||"query"===a.variant)&&e.bar2Indeterminate,"buffer"===a.variant&&e.bar2Buffer]}})((({ownerState:r,theme:e})=>(0,o.A)({width:"100%",position:"absolute",left:0,bottom:0,top:0,transition:"transform 0.2s linear",transformOrigin:"left"},"buffer"!==r.variant&&{backgroundColor:"inherit"===r.color?"currentColor":e.palette[r.color].main},"inherit"===r.color&&{opacity:.3},"buffer"===r.variant&&{backgroundColor:B(e,r.color),transition:"transform .4s linear"})),(({ownerState:r})=>("indeterminate"===r.variant||"query"===r.variant)&&(0,l.AH)(k||(k=S`
      width: auto;
      animation: ${0} 2.1s cubic-bezier(0.165, 0.84, 0.44, 1) 1.15s infinite;
    `),x))),N=n.forwardRef((function(r,e){const a=(0,b.A)({props:r,name:"MuiLinearProgress"}),{className:n,color:l="primary",value:u,valueBuffer:f,variant:m="indeterminate"}=a,g=(0,t.A)(a,v),A=(0,o.A)({},a,{color:l,variant:m}),y=(r=>{const{classes:e,variant:a,color:t}=r,o={root:["root",`color${(0,c.A)(t)}`,a],dashed:["dashed",`dashedColor${(0,c.A)(t)}`],bar1:["bar",`barColor${(0,c.A)(t)}`,("indeterminate"===a||"query"===a)&&"bar1Indeterminate","determinate"===a&&"bar1Determinate","buffer"===a&&"bar1Buffer"],bar2:["bar","buffer"!==a&&`barColor${(0,c.A)(t)}`,"buffer"===a&&`color${(0,c.A)(t)}`,("indeterminate"===a||"query"===a)&&"bar2Indeterminate","buffer"===a&&"bar2Buffer"]};return(0,s.A)(o,h,e)})(A),w=(0,d.A)(),C={},k={bar1:{},bar2:{}};if("determinate"===m||"buffer"===m)if(void 0!==u){C["aria-valuenow"]=Math.round(u),C["aria-valuemin"]=0,C["aria-valuemax"]=100;let r=u-100;"rtl"===w.direction&&(r=-r),k.bar1.transform=`translateX(${r}%)`}else 0;if("buffer"===m)if(void 0!==f){let r=(f||0)-100;"rtl"===w.direction&&(r=-r),k.bar2.transform=`translateX(${r}%)`}else 0;return(0,p.jsxs)(I,(0,o.A)({className:(0,i.A)(y.root,n),ownerState:A,role:"progressbar"},C,{ref:e},g,{children:["buffer"===m?(0,p.jsx)(q,{className:y.dashed,ownerState:A}):null,(0,p.jsx)(M,{className:y.bar1,ownerState:A,style:k.bar1}),"determinate"===m?null:(0,p.jsx)(L,{className:y.bar2,ownerState:A,style:k.bar2})]}))}))}}]);