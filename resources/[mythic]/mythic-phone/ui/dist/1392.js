"use strict";(self.webpackChunkmythic_phone=self.webpackChunkmythic_phone||[]).push([[1392,4362,142],{44362:(e,t,n)=>{n.r(t),n.d(t,{DeleteEmail:()=>s,GPSRoute:()=>u,Hyperlink:()=>p,ReadEmail:()=>c});var r=n(61541);function o(e){return o="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e},o(e)}function l(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function i(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?l(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):l(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function a(e,t,n){return(t=function(e){var t=function(e,t){if("object"!=o(e)||!e)return e;var n=e[Symbol.toPrimitive];if(void 0!==n){var r=n.call(e,t||"default");if("object"!=o(r))return r;throw new TypeError("@@toPrimitive must return a primitive value.")}return("string"===t?String:Number)(e)}(e,"string");return"symbol"==o(t)?t:t+""}(t))in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}var c=function(e){return function(t){r.A.send("ReadEmail",e._id).then((function(n){t({type:"UPDATE_DATA",payload:{type:"emails",id:e._id,data:i(i({},e),{},{unread:!1})}})})).catch((function(e){}))}},s=function(e){return function(t){r.A.send("DeleteEmail",e).then((function(){return t({type:"REMOVE_DATA",payload:{type:"emails",id:e}}),!0})).catch((function(e){return!1}))}},u=function(e,t){return function(n){r.A.send("GPSRoute",{id:e,location:t}).then((function(e){n({type:"ALERT_SHOW",payload:{alert:"GPS Marked"}})})).catch((function(e){n({type:"ALERT_SHOW",payload:{alert:"Unable To Mark Location On GPS"}})}))}},p=function(e,t){return function(n){r.A.send("Hyperlink",{id:e,hyperlink:t}).catch((function(e){n({type:"ALERT_SHOW",payload:{alert:"Unable To Open Hyperlink"}})}))}}},21392:(e,t,n)=>{n.r(t),n.d(t,{default:()=>w});var r=n(55429),o=n(15647),l=n(64965),i=n(142),a=n(79111),c=n(26573),s=n(44686),u=n(66304),p=n(32455),d=n(28744),f=n(45942),m=n(51698),y=n.n(m),b=n(26324),g=n(59530),v=n(44362),h=n(23470);function A(e,t){return function(e){if(Array.isArray(e))return e}(e)||function(e,t){var n=null==e?null:"undefined"!=typeof Symbol&&e[Symbol.iterator]||e["@@iterator"];if(null!=n){var r,o,l,i,a=[],c=!0,s=!1;try{if(l=(n=n.call(e)).next,0===t){if(Object(n)!==n)return;c=!1}else for(;!(c=(r=l.call(n)).done)&&(a.push(r.value),a.length!==t);c=!0);}catch(e){s=!0,o=e}finally{try{if(!c&&null!=n.return&&(i=n.return(),Object(i)!==i))return}finally{if(s)throw o}}return a}}(e,t)||function(e,t){if(e){if("string"==typeof e)return k(e,t);var n={}.toString.call(e).slice(8,-1);return"Object"===n&&e.constructor&&(n=e.constructor.name),"Map"===n||"Set"===n?Array.from(e):"Arguments"===n||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)?k(e,t):void 0}}(e,t)||function(){throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}()}function k(e,t){(null==t||t>e.length)&&(t=e.length);for(var n=0,r=Array(t);n<t;n++)r[n]=e[n];return r}var E=(0,f.A)((function(e){return{wrapper:{height:"100%",background:e.palette.secondary.main,overflowY:"auto",overflowX:"hidden","&::-webkit-scrollbar":{width:6},"&::-webkit-scrollbar-thumb":{background:"#ffffff52"},"&::-webkit-scrollbar-thumb:hover":{background:e.palette.primary.main},"&::-webkit-scrollbar-track":{background:"transparent"}},titleBar:{padding:15,textAlign:"center"},senderBar:{padding:15,textAlign:"left",lineHeight:"30px",backgroundColor:e.palette.secondary.light},sendTime:{margin:"0",marginTop:"10px",color:e.palette.text.main},expireBar:{padding:15,textAlign:"center",background:e.palette.error.main},emailTitle:{fontSize:20,fontWeight:"bold",width:"100%",overflow:"hidden",textOverflow:"ellipsis",whiteSpace:"nowrap",lineHeight:"46px"},avatar:{color:e.palette.text.light,height:55,width:55,position:"relative",top:0},sender:{fontSize:18,color:e.palette.text.light},recipient:{fontSize:14,color:e.palette.text.main},emailBody:{padding:20,background:e.palette.secondary.dark,overflowX:"hidden",overflowY:"auto","&::-webkit-scrollbar":{width:6},"&::-webkit-scrollbar-thumb":{background:"#ffffff52"},"&::-webkit-scrollbar-thumb:hover":{background:e.palette.primary.main},"&::-webkit-scrollbar-track":{background:"transparent"}},actionButtons:{right:0}}})),x={lastDay:"[Yesterday at] LT",sameDay:"[Today at] LT",nextDay:"[Tomorrow at] LT",lastWeek:"[last] dddd [at] LT",nextWeek:"dddd [at] LT",sameElse:"L"};const w=(0,o.Ng)(null,{ReadEmail:v.ReadEmail,DeleteEmail:v.DeleteEmail,GPSRoute:v.GPSRoute,Hyperlink:v.Hyperlink})((function(e){var t,n,f,m,v,k=(0,h.MW)(),w=E(),S=(0,l.W6)(),O=e.match.params.id,D=(0,o.d4)((function(e){return e.data.data.emails})).filter((function(e){return e._id===O}))[0];(0,r.useEffect)((function(){var t,n=null;return D||(k("Email Has Been Deleted"),S.goBack()),null!=D&&D.unread&&e.ReadEmail(D),null!=(null==D||null===(t=D.flags)||void 0===t?void 0:t.expires)&&(D.flags.expires<Date.now()?(k("Email Has Expired"),e.DeleteEmail(D._id),S.goBack()):n=setInterval((function(){D.flags.expires<Date.now()&&(k("Email Has Expired"),e.DeleteEmail(D._id),S.goBack())}),2500)),function(){clearInterval(n)}}),[D]);var T=A((0,r.useState)(!1),2),B=T[0],P=T[1],j=A((0,r.useState)({left:110,top:0}),2),R=j[0],C=j[1],N=function(){P(!1)};return r.createElement("div",{className:w.wrapper},r.createElement(i.A,{position:"static"},r.createElement(a.Ay,{container:!0,className:w.titleBar},r.createElement(a.Ay,{item:!0,xs:2,style:{textAlign:"left"}},r.createElement(c.A,{onClick:function(){return S.goBack()}},r.createElement(g.g,{icon:["fas","arrow-left"]}))),r.createElement(a.Ay,{item:!0,xs:8,className:w.emailTitle,title:null==D?void 0:D.subject},null==D?void 0:D.subject),r.createElement(a.Ay,{item:!0,xs:2,style:{textAlign:"right"}},r.createElement(c.A,{onClick:function(e){e.preventDefault(),C({left:e.clientX-2,top:e.clientY-4}),P(!0)}},r.createElement(g.g,{icon:["fas","ellipsis-vertical"]})))),r.createElement(a.Ay,{container:!0,className:w.senderBar},r.createElement(a.Ay,{item:!0,xs:2},r.createElement(s.A,{className:w.avatar},null==D||null===(t=D.sender)||void 0===t?void 0:t.charAt(0))),r.createElement(a.Ay,{item:!0,xs:10,style:{overflow:"hidden",whiteSpace:"nowrap",textOverflow:"ellipsis"}},r.createElement("div",{className:w.sender},null==D?void 0:D.sender),r.createElement("div",{className:w.recipient},"to: me")),r.createElement(a.Ay,{item:!0,xs:8,style:{textAlign:"left",position:"relative"}},r.createElement("p",{className:w.sendTime},"Received ",r.createElement(y(),{interval:6e4,fromNow:!0},+(null==D?void 0:D.time)),".")),r.createElement(a.Ay,{item:!0,xs:4,style:{textAlign:"right",position:"relative"}},r.createElement("div",{className:w.actionButtons},null!=(null==D||null===(n=D.flags)||void 0===n?void 0:n.location)?r.createElement(c.A,{onClick:function(){var t;null!=(null==D||null===(t=D.flags)||void 0===t?void 0:t.location)&&e.GPSRoute(D._id,D.flags.location)}},r.createElement(g.g,{icon:["fas","location-crosshairs"]})):null,null!=(null==D||null===(f=D.flags)||void 0===f?void 0:f.hyperlink)?r.createElement(c.A,{onClick:function(){var t;null!=(null==D||null===(t=D.flags)||void 0===t?void 0:t.hyperlink)&&e.Hyperlink(D._id,D.flags.hyperlink)}},r.createElement(g.g,{icon:["fas","link"]})):null)))),r.createElement(u.A,{anchorReference:"anchorPosition",anchorPosition:R,keepMounted:!0,open:B,onClose:N},r.createElement(p.A,{onClick:function(){N(),k("Email Deleted"),e.DeleteEmail(D._id),S.goBack()}},"Delete Email")),null!=(null==D||null===(m=D.flags)||void 0===m?void 0:m.expires)?r.createElement(i.A,{className:w.expireBar,position:"static"},r.createElement("div",null,"Email expires"," ",r.createElement(y(),{interval:1e4,calendar:x,fromNow:!0},+D.flags.expires))):null,r.createElement(d.A,{className:w.emailBody,style:{height:null!=(null==D||null===(v=D.flags)||void 0===v?void 0:v.expires)?"66.6%":"73.5%"}},(0,b.WX)(null==D?void 0:D.body)))}))},142:(e,t,n)=>{n.d(t,{A:()=>g});var r=n(86887),o=n(64180),l=n(55429),i=n(1551),a=n(50035),c=n(94526),s=n(88594),u=n(69921),p=n(28744),d=n(35457);function f(e){return(0,d.A)("MuiAppBar",e)}(0,n(40725).A)("MuiAppBar",["root","positionFixed","positionAbsolute","positionSticky","positionStatic","positionRelative","colorDefault","colorPrimary","colorSecondary","colorInherit","colorTransparent"]);var m=n(64922);const y=["className","color","enableColorOnDark","position"],b=(0,c.Ay)(p.A,{name:"MuiAppBar",slot:"Root",overridesResolver:(e,t)=>{const{ownerState:n}=e;return[t.root,t[`position${(0,u.A)(n.position)}`],t[`color${(0,u.A)(n.color)}`]]}})((({theme:e,ownerState:t})=>{const n="light"===e.palette.mode?e.palette.grey[100]:e.palette.grey[900];return(0,o.A)({display:"flex",flexDirection:"column",width:"100%",boxSizing:"border-box",flexShrink:0},"fixed"===t.position&&{position:"fixed",zIndex:e.zIndex.appBar,top:0,left:"auto",right:0,"@media print":{position:"absolute"}},"absolute"===t.position&&{position:"absolute",zIndex:e.zIndex.appBar,top:0,left:"auto",right:0},"sticky"===t.position&&{position:"sticky",zIndex:e.zIndex.appBar,top:0,left:"auto",right:0},"static"===t.position&&{position:"static"},"relative"===t.position&&{position:"relative"},"default"===t.color&&{backgroundColor:n,color:e.palette.getContrastText(n)},t.color&&"default"!==t.color&&"inherit"!==t.color&&"transparent"!==t.color&&{backgroundColor:e.palette[t.color].main,color:e.palette[t.color].contrastText},"inherit"===t.color&&{color:"inherit"},"dark"===e.palette.mode&&!t.enableColorOnDark&&{backgroundColor:null,color:null},"transparent"===t.color&&(0,o.A)({backgroundColor:"transparent",color:"inherit"},"dark"===e.palette.mode&&{backgroundImage:"none"}))})),g=l.forwardRef((function(e,t){const n=(0,s.A)({props:e,name:"MuiAppBar"}),{className:l,color:c="primary",enableColorOnDark:p=!1,position:d="fixed"}=n,g=(0,r.A)(n,y),v=(0,o.A)({},n,{color:c,position:d,enableColorOnDark:p}),h=(e=>{const{color:t,position:n,classes:r}=e,o={root:["root",`color${(0,u.A)(t)}`,`position${(0,u.A)(n)}`]};return(0,a.A)(o,f,r)})(v);return(0,m.jsx)(b,(0,o.A)({square:!0,component:"header",ownerState:v,elevation:4,className:(0,i.A)(h.root,l,"fixed"===d&&"mui-fixed"),ref:t},g))}))}}]);