"use strict";(self.webpackChunkmythic_phone=self.webpackChunkmythic_phone||[]).push([[6666],{40974:(e,t,n)=>{n.d(t,{A:()=>Le});var r=n(64180),o=n(86887),i=n(55429);function a(e){if(null==e)return window;if("[object Window]"!==e.toString()){var t=e.ownerDocument;return t&&t.defaultView||window}return e}function s(e){return e instanceof a(e).Element||e instanceof Element}function f(e){return e instanceof a(e).HTMLElement||e instanceof HTMLElement}function c(e){return"undefined"!=typeof ShadowRoot&&(e instanceof a(e).ShadowRoot||e instanceof ShadowRoot)}var p=Math.max,u=Math.min,l=Math.round;function d(){var e=navigator.userAgentData;return null!=e&&e.brands&&Array.isArray(e.brands)?e.brands.map((function(e){return e.brand+"/"+e.version})).join(" "):navigator.userAgent}function m(){return!/^((?!chrome|android).)*safari/i.test(d())}function h(e,t,n){void 0===t&&(t=!1),void 0===n&&(n=!1);var r=e.getBoundingClientRect(),o=1,i=1;t&&f(e)&&(o=e.offsetWidth>0&&l(r.width)/e.offsetWidth||1,i=e.offsetHeight>0&&l(r.height)/e.offsetHeight||1);var c=(s(e)?a(e):window).visualViewport,p=!m()&&n,u=(r.left+(p&&c?c.offsetLeft:0))/o,d=(r.top+(p&&c?c.offsetTop:0))/i,h=r.width/o,v=r.height/i;return{width:h,height:v,top:d,right:u+h,bottom:d+v,left:u,x:u,y:d}}function v(e){var t=a(e);return{scrollLeft:t.pageXOffset,scrollTop:t.pageYOffset}}function y(e){return e?(e.nodeName||"").toLowerCase():null}function g(e){return((s(e)?e.ownerDocument:e.document)||window.document).documentElement}function b(e){return h(g(e)).left+v(e).scrollLeft}function w(e){return a(e).getComputedStyle(e)}function x(e){var t=w(e),n=t.overflow,r=t.overflowX,o=t.overflowY;return/auto|scroll|overlay|hidden/.test(n+o+r)}function O(e,t,n){void 0===n&&(n=!1);var r,o,i=f(t),s=f(t)&&function(e){var t=e.getBoundingClientRect(),n=l(t.width)/e.offsetWidth||1,r=l(t.height)/e.offsetHeight||1;return 1!==n||1!==r}(t),c=g(t),p=h(e,s,n),u={scrollLeft:0,scrollTop:0},d={x:0,y:0};return(i||!i&&!n)&&(("body"!==y(t)||x(c))&&(u=(r=t)!==a(r)&&f(r)?{scrollLeft:(o=r).scrollLeft,scrollTop:o.scrollTop}:v(r)),f(t)?((d=h(t,!0)).x+=t.clientLeft,d.y+=t.clientTop):c&&(d.x=b(c))),{x:p.left+u.scrollLeft-d.x,y:p.top+u.scrollTop-d.y,width:p.width,height:p.height}}function A(e){var t=h(e),n=e.offsetWidth,r=e.offsetHeight;return Math.abs(t.width-n)<=1&&(n=t.width),Math.abs(t.height-r)<=1&&(r=t.height),{x:e.offsetLeft,y:e.offsetTop,width:n,height:r}}function E(e){return"html"===y(e)?e:e.assignedSlot||e.parentNode||(c(e)?e.host:null)||g(e)}function j(e){return["html","body","#document"].indexOf(y(e))>=0?e.ownerDocument.body:f(e)&&x(e)?e:j(E(e))}function D(e,t){var n;void 0===t&&(t=[]);var r=j(e),o=r===(null==(n=e.ownerDocument)?void 0:n.body),i=a(r),s=o?[i].concat(i.visualViewport||[],x(r)?r:[]):r,f=t.concat(s);return o?f:f.concat(D(E(s)))}function P(e){return["table","td","th"].indexOf(y(e))>=0}function k(e){return f(e)&&"fixed"!==w(e).position?e.offsetParent:null}function R(e){for(var t=a(e),n=k(e);n&&P(n)&&"static"===w(n).position;)n=k(n);return n&&("html"===y(n)||"body"===y(n)&&"static"===w(n).position)?t:n||function(e){var t=/firefox/i.test(d());if(/Trident/i.test(d())&&f(e)&&"fixed"===w(e).position)return null;var n=E(e);for(c(n)&&(n=n.host);f(n)&&["html","body"].indexOf(y(n))<0;){var r=w(n);if("none"!==r.transform||"none"!==r.perspective||"paint"===r.contain||-1!==["transform","perspective"].indexOf(r.willChange)||t&&"filter"===r.willChange||t&&r.filter&&"none"!==r.filter)return n;n=n.parentNode}return null}(e)||t}var M="top",L="bottom",W="right",B="left",T="auto",H=[M,L,W,B],S="start",C="end",V="clippingParents",q="viewport",N="popper",I="reference",U=H.reduce((function(e,t){return e.concat([t+"-"+S,t+"-"+C])}),[]),_=[].concat(H,[T]).reduce((function(e,t){return e.concat([t,t+"-"+S,t+"-"+C])}),[]),F=["beforeRead","read","afterRead","beforeMain","main","afterMain","beforeWrite","write","afterWrite"];function z(e){var t=new Map,n=new Set,r=[];function o(e){n.add(e.name),[].concat(e.requires||[],e.requiresIfExists||[]).forEach((function(e){if(!n.has(e)){var r=t.get(e);r&&o(r)}})),r.push(e)}return e.forEach((function(e){t.set(e.name,e)})),e.forEach((function(e){n.has(e.name)||o(e)})),r}var X={placement:"bottom",modifiers:[],strategy:"absolute"};function Y(){for(var e=arguments.length,t=new Array(e),n=0;n<e;n++)t[n]=arguments[n];return!t.some((function(e){return!(e&&"function"==typeof e.getBoundingClientRect)}))}function $(e){void 0===e&&(e={});var t=e,n=t.defaultModifiers,r=void 0===n?[]:n,o=t.defaultOptions,i=void 0===o?X:o;return function(e,t,n){void 0===n&&(n=i);var o,a,f={placement:"bottom",orderedModifiers:[],options:Object.assign({},X,i),modifiersData:{},elements:{reference:e,popper:t},attributes:{},styles:{}},c=[],p=!1,u={state:f,setOptions:function(n){var o="function"==typeof n?n(f.options):n;l(),f.options=Object.assign({},i,f.options,o),f.scrollParents={reference:s(e)?D(e):e.contextElement?D(e.contextElement):[],popper:D(t)};var a,p,d=function(e){var t=z(e);return F.reduce((function(e,n){return e.concat(t.filter((function(e){return e.phase===n})))}),[])}((a=[].concat(r,f.options.modifiers),p=a.reduce((function(e,t){var n=e[t.name];return e[t.name]=n?Object.assign({},n,t,{options:Object.assign({},n.options,t.options),data:Object.assign({},n.data,t.data)}):t,e}),{}),Object.keys(p).map((function(e){return p[e]}))));return f.orderedModifiers=d.filter((function(e){return e.enabled})),f.orderedModifiers.forEach((function(e){var t=e.name,n=e.options,r=void 0===n?{}:n,o=e.effect;if("function"==typeof o){var i=o({state:f,name:t,instance:u,options:r}),a=function(){};c.push(i||a)}})),u.update()},forceUpdate:function(){if(!p){var e=f.elements,t=e.reference,n=e.popper;if(Y(t,n)){f.rects={reference:O(t,R(n),"fixed"===f.options.strategy),popper:A(n)},f.reset=!1,f.placement=f.options.placement,f.orderedModifiers.forEach((function(e){return f.modifiersData[e.name]=Object.assign({},e.data)}));for(var r=0;r<f.orderedModifiers.length;r++)if(!0!==f.reset){var o=f.orderedModifiers[r],i=o.fn,a=o.options,s=void 0===a?{}:a,c=o.name;"function"==typeof i&&(f=i({state:f,options:s,name:c,instance:u})||f)}else f.reset=!1,r=-1}}},update:(o=function(){return new Promise((function(e){u.forceUpdate(),e(f)}))},function(){return a||(a=new Promise((function(e){Promise.resolve().then((function(){a=void 0,e(o())}))}))),a}),destroy:function(){l(),p=!0}};if(!Y(e,t))return u;function l(){c.forEach((function(e){return e()})),c=[]}return u.setOptions(n).then((function(e){!p&&n.onFirstUpdate&&n.onFirstUpdate(e)})),u}}var G={passive:!0};function J(e){return e.split("-")[0]}function K(e){return e.split("-")[1]}function Q(e){return["top","bottom"].indexOf(e)>=0?"x":"y"}function Z(e){var t,n=e.reference,r=e.element,o=e.placement,i=o?J(o):null,a=o?K(o):null,s=n.x+n.width/2-r.width/2,f=n.y+n.height/2-r.height/2;switch(i){case M:t={x:s,y:n.y-r.height};break;case L:t={x:s,y:n.y+n.height};break;case W:t={x:n.x+n.width,y:f};break;case B:t={x:n.x-r.width,y:f};break;default:t={x:n.x,y:n.y}}var c=i?Q(i):null;if(null!=c){var p="y"===c?"height":"width";switch(a){case S:t[c]=t[c]-(n[p]/2-r[p]/2);break;case C:t[c]=t[c]+(n[p]/2-r[p]/2)}}return t}var ee={top:"auto",right:"auto",bottom:"auto",left:"auto"};function te(e){var t,n=e.popper,r=e.popperRect,o=e.placement,i=e.variation,s=e.offsets,f=e.position,c=e.gpuAcceleration,p=e.adaptive,u=e.roundOffsets,d=e.isFixed,m=s.x,h=void 0===m?0:m,v=s.y,y=void 0===v?0:v,b="function"==typeof u?u({x:h,y}):{x:h,y};h=b.x,y=b.y;var x=s.hasOwnProperty("x"),O=s.hasOwnProperty("y"),A=B,E=M,j=window;if(p){var D=R(n),P="clientHeight",k="clientWidth";if(D===a(n)&&"static"!==w(D=g(n)).position&&"absolute"===f&&(P="scrollHeight",k="scrollWidth"),o===M||(o===B||o===W)&&i===C)E=L,y-=(d&&D===j&&j.visualViewport?j.visualViewport.height:D[P])-r.height,y*=c?1:-1;if(o===B||(o===M||o===L)&&i===C)A=W,h-=(d&&D===j&&j.visualViewport?j.visualViewport.width:D[k])-r.width,h*=c?1:-1}var T,H=Object.assign({position:f},p&&ee),S=!0===u?function(e,t){var n=e.x,r=e.y,o=t.devicePixelRatio||1;return{x:l(n*o)/o||0,y:l(r*o)/o||0}}({x:h,y},a(n)):{x:h,y};return h=S.x,y=S.y,c?Object.assign({},H,((T={})[E]=O?"0":"",T[A]=x?"0":"",T.transform=(j.devicePixelRatio||1)<=1?"translate("+h+"px, "+y+"px)":"translate3d("+h+"px, "+y+"px, 0)",T)):Object.assign({},H,((t={})[E]=O?y+"px":"",t[A]=x?h+"px":"",t.transform="",t))}const ne={name:"offset",enabled:!0,phase:"main",requires:["popperOffsets"],fn:function(e){var t=e.state,n=e.options,r=e.name,o=n.offset,i=void 0===o?[0,0]:o,a=_.reduce((function(e,n){return e[n]=function(e,t,n){var r=J(e),o=[B,M].indexOf(r)>=0?-1:1,i="function"==typeof n?n(Object.assign({},t,{placement:e})):n,a=i[0],s=i[1];return a=a||0,s=(s||0)*o,[B,W].indexOf(r)>=0?{x:s,y:a}:{x:a,y:s}}(n,t.rects,i),e}),{}),s=a[t.placement],f=s.x,c=s.y;null!=t.modifiersData.popperOffsets&&(t.modifiersData.popperOffsets.x+=f,t.modifiersData.popperOffsets.y+=c),t.modifiersData[r]=a}};var re={left:"right",right:"left",bottom:"top",top:"bottom"};function oe(e){return e.replace(/left|right|bottom|top/g,(function(e){return re[e]}))}var ie={start:"end",end:"start"};function ae(e){return e.replace(/start|end/g,(function(e){return ie[e]}))}function se(e,t){var n=t.getRootNode&&t.getRootNode();if(e.contains(t))return!0;if(n&&c(n)){var r=t;do{if(r&&e.isSameNode(r))return!0;r=r.parentNode||r.host}while(r)}return!1}function fe(e){return Object.assign({},e,{left:e.x,top:e.y,right:e.x+e.width,bottom:e.y+e.height})}function ce(e,t,n){return t===q?fe(function(e,t){var n=a(e),r=g(e),o=n.visualViewport,i=r.clientWidth,s=r.clientHeight,f=0,c=0;if(o){i=o.width,s=o.height;var p=m();(p||!p&&"fixed"===t)&&(f=o.offsetLeft,c=o.offsetTop)}return{width:i,height:s,x:f+b(e),y:c}}(e,n)):s(t)?function(e,t){var n=h(e,!1,"fixed"===t);return n.top=n.top+e.clientTop,n.left=n.left+e.clientLeft,n.bottom=n.top+e.clientHeight,n.right=n.left+e.clientWidth,n.width=e.clientWidth,n.height=e.clientHeight,n.x=n.left,n.y=n.top,n}(t,n):fe(function(e){var t,n=g(e),r=v(e),o=null==(t=e.ownerDocument)?void 0:t.body,i=p(n.scrollWidth,n.clientWidth,o?o.scrollWidth:0,o?o.clientWidth:0),a=p(n.scrollHeight,n.clientHeight,o?o.scrollHeight:0,o?o.clientHeight:0),s=-r.scrollLeft+b(e),f=-r.scrollTop;return"rtl"===w(o||n).direction&&(s+=p(n.clientWidth,o?o.clientWidth:0)-i),{width:i,height:a,x:s,y:f}}(g(e)))}function pe(e,t,n,r){var o="clippingParents"===t?function(e){var t=D(E(e)),n=["absolute","fixed"].indexOf(w(e).position)>=0&&f(e)?R(e):e;return s(n)?t.filter((function(e){return s(e)&&se(e,n)&&"body"!==y(e)})):[]}(e):[].concat(t),i=[].concat(o,[n]),a=i[0],c=i.reduce((function(t,n){var o=ce(e,n,r);return t.top=p(o.top,t.top),t.right=u(o.right,t.right),t.bottom=u(o.bottom,t.bottom),t.left=p(o.left,t.left),t}),ce(e,a,r));return c.width=c.right-c.left,c.height=c.bottom-c.top,c.x=c.left,c.y=c.top,c}function ue(e){return Object.assign({},{top:0,right:0,bottom:0,left:0},e)}function le(e,t){return t.reduce((function(t,n){return t[n]=e,t}),{})}function de(e,t){void 0===t&&(t={});var n=t,r=n.placement,o=void 0===r?e.placement:r,i=n.strategy,a=void 0===i?e.strategy:i,f=n.boundary,c=void 0===f?V:f,p=n.rootBoundary,u=void 0===p?q:p,l=n.elementContext,d=void 0===l?N:l,m=n.altBoundary,v=void 0!==m&&m,y=n.padding,b=void 0===y?0:y,w=ue("number"!=typeof b?b:le(b,H)),x=d===N?I:N,O=e.rects.popper,A=e.elements[v?x:d],E=pe(s(A)?A:A.contextElement||g(e.elements.popper),c,u,a),j=h(e.elements.reference),D=Z({reference:j,element:O,strategy:"absolute",placement:o}),P=fe(Object.assign({},O,D)),k=d===N?P:j,R={top:E.top-k.top+w.top,bottom:k.bottom-E.bottom+w.bottom,left:E.left-k.left+w.left,right:k.right-E.right+w.right},B=e.modifiersData.offset;if(d===N&&B){var T=B[o];Object.keys(R).forEach((function(e){var t=[W,L].indexOf(e)>=0?1:-1,n=[M,L].indexOf(e)>=0?"y":"x";R[e]+=T[n]*t}))}return R}function me(e,t,n){return p(e,u(t,n))}const he={name:"preventOverflow",enabled:!0,phase:"main",fn:function(e){var t=e.state,n=e.options,r=e.name,o=n.mainAxis,i=void 0===o||o,a=n.altAxis,s=void 0!==a&&a,f=n.boundary,c=n.rootBoundary,l=n.altBoundary,d=n.padding,m=n.tether,h=void 0===m||m,v=n.tetherOffset,y=void 0===v?0:v,g=de(t,{boundary:f,rootBoundary:c,padding:d,altBoundary:l}),b=J(t.placement),w=K(t.placement),x=!w,O=Q(b),E="x"===O?"y":"x",j=t.modifiersData.popperOffsets,D=t.rects.reference,P=t.rects.popper,k="function"==typeof y?y(Object.assign({},t.rects,{placement:t.placement})):y,T="number"==typeof k?{mainAxis:k,altAxis:k}:Object.assign({mainAxis:0,altAxis:0},k),H=t.modifiersData.offset?t.modifiersData.offset[t.placement]:null,C={x:0,y:0};if(j){if(i){var V,q="y"===O?M:B,N="y"===O?L:W,I="y"===O?"height":"width",U=j[O],_=U+g[q],F=U-g[N],z=h?-P[I]/2:0,X=w===S?D[I]:P[I],Y=w===S?-P[I]:-D[I],$=t.elements.arrow,G=h&&$?A($):{width:0,height:0},Z=t.modifiersData["arrow#persistent"]?t.modifiersData["arrow#persistent"].padding:{top:0,right:0,bottom:0,left:0},ee=Z[q],te=Z[N],ne=me(0,D[I],G[I]),re=x?D[I]/2-z-ne-ee-T.mainAxis:X-ne-ee-T.mainAxis,oe=x?-D[I]/2+z+ne+te+T.mainAxis:Y+ne+te+T.mainAxis,ie=t.elements.arrow&&R(t.elements.arrow),ae=ie?"y"===O?ie.clientTop||0:ie.clientLeft||0:0,se=null!=(V=null==H?void 0:H[O])?V:0,fe=U+oe-se,ce=me(h?u(_,U+re-se-ae):_,U,h?p(F,fe):F);j[O]=ce,C[O]=ce-U}if(s){var pe,ue="x"===O?M:B,le="x"===O?L:W,he=j[E],ve="y"===E?"height":"width",ye=he+g[ue],ge=he-g[le],be=-1!==[M,B].indexOf(b),we=null!=(pe=null==H?void 0:H[E])?pe:0,xe=be?ye:he-D[ve]-P[ve]-we+T.altAxis,Oe=be?he+D[ve]+P[ve]-we-T.altAxis:ge,Ae=h&&be?function(e,t,n){var r=me(e,t,n);return r>n?n:r}(xe,he,Oe):me(h?xe:ye,he,h?Oe:ge);j[E]=Ae,C[E]=Ae-he}t.modifiersData[r]=C}},requiresIfExists:["offset"]};const ve={name:"arrow",enabled:!0,phase:"main",fn:function(e){var t,n=e.state,r=e.name,o=e.options,i=n.elements.arrow,a=n.modifiersData.popperOffsets,s=J(n.placement),f=Q(s),c=[B,W].indexOf(s)>=0?"height":"width";if(i&&a){var p=function(e,t){return ue("number"!=typeof(e="function"==typeof e?e(Object.assign({},t.rects,{placement:t.placement})):e)?e:le(e,H))}(o.padding,n),u=A(i),l="y"===f?M:B,d="y"===f?L:W,m=n.rects.reference[c]+n.rects.reference[f]-a[f]-n.rects.popper[c],h=a[f]-n.rects.reference[f],v=R(i),y=v?"y"===f?v.clientHeight||0:v.clientWidth||0:0,g=m/2-h/2,b=p[l],w=y-u[c]-p[d],x=y/2-u[c]/2+g,O=me(b,x,w),E=f;n.modifiersData[r]=((t={})[E]=O,t.centerOffset=O-x,t)}},effect:function(e){var t=e.state,n=e.options.element,r=void 0===n?"[data-popper-arrow]":n;null!=r&&("string"!=typeof r||(r=t.elements.popper.querySelector(r)))&&se(t.elements.popper,r)&&(t.elements.arrow=r)},requires:["popperOffsets"],requiresIfExists:["preventOverflow"]};function ye(e,t,n){return void 0===n&&(n={x:0,y:0}),{top:e.top-t.height-n.y,right:e.right-t.width+n.x,bottom:e.bottom-t.height+n.y,left:e.left-t.width-n.x}}function ge(e){return[M,W,L,B].some((function(t){return e[t]>=0}))}var be=$({defaultModifiers:[{name:"eventListeners",enabled:!0,phase:"write",fn:function(){},effect:function(e){var t=e.state,n=e.instance,r=e.options,o=r.scroll,i=void 0===o||o,s=r.resize,f=void 0===s||s,c=a(t.elements.popper),p=[].concat(t.scrollParents.reference,t.scrollParents.popper);return i&&p.forEach((function(e){e.addEventListener("scroll",n.update,G)})),f&&c.addEventListener("resize",n.update,G),function(){i&&p.forEach((function(e){e.removeEventListener("scroll",n.update,G)})),f&&c.removeEventListener("resize",n.update,G)}},data:{}},{name:"popperOffsets",enabled:!0,phase:"read",fn:function(e){var t=e.state,n=e.name;t.modifiersData[n]=Z({reference:t.rects.reference,element:t.rects.popper,strategy:"absolute",placement:t.placement})},data:{}},{name:"computeStyles",enabled:!0,phase:"beforeWrite",fn:function(e){var t=e.state,n=e.options,r=n.gpuAcceleration,o=void 0===r||r,i=n.adaptive,a=void 0===i||i,s=n.roundOffsets,f=void 0===s||s,c={placement:J(t.placement),variation:K(t.placement),popper:t.elements.popper,popperRect:t.rects.popper,gpuAcceleration:o,isFixed:"fixed"===t.options.strategy};null!=t.modifiersData.popperOffsets&&(t.styles.popper=Object.assign({},t.styles.popper,te(Object.assign({},c,{offsets:t.modifiersData.popperOffsets,position:t.options.strategy,adaptive:a,roundOffsets:f})))),null!=t.modifiersData.arrow&&(t.styles.arrow=Object.assign({},t.styles.arrow,te(Object.assign({},c,{offsets:t.modifiersData.arrow,position:"absolute",adaptive:!1,roundOffsets:f})))),t.attributes.popper=Object.assign({},t.attributes.popper,{"data-popper-placement":t.placement})},data:{}},{name:"applyStyles",enabled:!0,phase:"write",fn:function(e){var t=e.state;Object.keys(t.elements).forEach((function(e){var n=t.styles[e]||{},r=t.attributes[e]||{},o=t.elements[e];f(o)&&y(o)&&(Object.assign(o.style,n),Object.keys(r).forEach((function(e){var t=r[e];!1===t?o.removeAttribute(e):o.setAttribute(e,!0===t?"":t)})))}))},effect:function(e){var t=e.state,n={popper:{position:t.options.strategy,left:"0",top:"0",margin:"0"},arrow:{position:"absolute"},reference:{}};return Object.assign(t.elements.popper.style,n.popper),t.styles=n,t.elements.arrow&&Object.assign(t.elements.arrow.style,n.arrow),function(){Object.keys(t.elements).forEach((function(e){var r=t.elements[e],o=t.attributes[e]||{},i=Object.keys(t.styles.hasOwnProperty(e)?t.styles[e]:n[e]).reduce((function(e,t){return e[t]="",e}),{});f(r)&&y(r)&&(Object.assign(r.style,i),Object.keys(o).forEach((function(e){r.removeAttribute(e)})))}))}},requires:["computeStyles"]},ne,{name:"flip",enabled:!0,phase:"main",fn:function(e){var t=e.state,n=e.options,r=e.name;if(!t.modifiersData[r]._skip){for(var o=n.mainAxis,i=void 0===o||o,a=n.altAxis,s=void 0===a||a,f=n.fallbackPlacements,c=n.padding,p=n.boundary,u=n.rootBoundary,l=n.altBoundary,d=n.flipVariations,m=void 0===d||d,h=n.allowedAutoPlacements,v=t.options.placement,y=J(v),g=f||(y===v||!m?[oe(v)]:function(e){if(J(e)===T)return[];var t=oe(e);return[ae(e),t,ae(t)]}(v)),b=[v].concat(g).reduce((function(e,n){return e.concat(J(n)===T?function(e,t){void 0===t&&(t={});var n=t,r=n.placement,o=n.boundary,i=n.rootBoundary,a=n.padding,s=n.flipVariations,f=n.allowedAutoPlacements,c=void 0===f?_:f,p=K(r),u=p?s?U:U.filter((function(e){return K(e)===p})):H,l=u.filter((function(e){return c.indexOf(e)>=0}));0===l.length&&(l=u);var d=l.reduce((function(t,n){return t[n]=de(e,{placement:n,boundary:o,rootBoundary:i,padding:a})[J(n)],t}),{});return Object.keys(d).sort((function(e,t){return d[e]-d[t]}))}(t,{placement:n,boundary:p,rootBoundary:u,padding:c,flipVariations:m,allowedAutoPlacements:h}):n)}),[]),w=t.rects.reference,x=t.rects.popper,O=new Map,A=!0,E=b[0],j=0;j<b.length;j++){var D=b[j],P=J(D),k=K(D)===S,R=[M,L].indexOf(P)>=0,C=R?"width":"height",V=de(t,{placement:D,boundary:p,rootBoundary:u,altBoundary:l,padding:c}),q=R?k?W:B:k?L:M;w[C]>x[C]&&(q=oe(q));var N=oe(q),I=[];if(i&&I.push(V[P]<=0),s&&I.push(V[q]<=0,V[N]<=0),I.every((function(e){return e}))){E=D,A=!1;break}O.set(D,I)}if(A)for(var F=function(e){var t=b.find((function(t){var n=O.get(t);if(n)return n.slice(0,e).every((function(e){return e}))}));if(t)return E=t,"break"},z=m?3:1;z>0;z--){if("break"===F(z))break}t.placement!==E&&(t.modifiersData[r]._skip=!0,t.placement=E,t.reset=!0)}},requiresIfExists:["offset"],data:{_skip:!1}},he,ve,{name:"hide",enabled:!0,phase:"main",requiresIfExists:["preventOverflow"],fn:function(e){var t=e.state,n=e.name,r=t.rects.reference,o=t.rects.popper,i=t.modifiersData.preventOverflow,a=de(t,{elementContext:"reference"}),s=de(t,{altBoundary:!0}),f=ye(a,r),c=ye(s,o,i),p=ge(f),u=ge(c);t.modifiersData[n]={referenceClippingOffsets:f,popperEscapeOffsets:c,isReferenceHidden:p,hasPopperEscaped:u},t.attributes.popper=Object.assign({},t.attributes.popper,{"data-popper-reference-hidden":p,"data-popper-escaped":u})}}]}),we=n(90354),xe=n(87875),Oe=n(71729),Ae=n(19699),Ee=n(38339),je=n(64922);const De=["anchorEl","children","disablePortal","modifiers","open","placement","popperOptions","popperRef","TransitionProps"],Pe=["anchorEl","children","container","disablePortal","keepMounted","modifiers","open","placement","popperOptions","popperRef","style","transition"];function ke(e){return"function"==typeof e?e():e}const Re={},Me=i.forwardRef((function(e,t){const{anchorEl:n,children:a,disablePortal:s,modifiers:f,open:c,placement:p,popperOptions:u,popperRef:l,TransitionProps:d}=e,m=(0,o.A)(e,De),h=i.useRef(null),v=(0,Ae.A)(h,t),y=i.useRef(null),g=(0,Ae.A)(y,l),b=i.useRef(g);(0,Ee.A)((()=>{b.current=g}),[g]),i.useImperativeHandle(l,(()=>y.current),[]);const w=function(e,t){if("ltr"===(t&&t.direction||"ltr"))return e;switch(e){case"bottom-end":return"bottom-start";case"bottom-start":return"bottom-end";case"top-end":return"top-start";case"top-start":return"top-end";default:return e}}(p,(0,we.A)()),[x,O]=i.useState(w);i.useEffect((()=>{y.current&&y.current.forceUpdate()})),(0,Ee.A)((()=>{if(!n||!c)return;ke(n);let e=[{name:"preventOverflow",options:{altBoundary:s}},{name:"flip",options:{altBoundary:s}},{name:"onUpdate",enabled:!0,phase:"afterWrite",fn:({state:e})=>{O(e.placement)}}];null!=f&&(e=e.concat(f)),u&&null!=u.modifiers&&(e=e.concat(u.modifiers));const t=be(ke(n),h.current,(0,r.A)({placement:w},u,{modifiers:e}));return b.current(t),()=>{t.destroy(),b.current(null)}}),[n,s,f,c,u,w]);const A={placement:x};return null!==d&&(A.TransitionProps=d),(0,je.jsx)("div",(0,r.A)({ref:v,role:"tooltip"},m,{children:"function"==typeof a?a(A):a}))})),Le=i.forwardRef((function(e,t){const{anchorEl:n,children:a,container:s,disablePortal:f=!1,keepMounted:c=!1,modifiers:p,open:u,placement:l="bottom",popperOptions:d=Re,popperRef:m,style:h,transition:v=!1}=e,y=(0,o.A)(e,Pe),[g,b]=i.useState(!0);if(!c&&!u&&(!v||g))return null;const w=s||(n?(0,Oe.A)(ke(n)).body:void 0);return(0,je.jsx)(xe.A,{disablePortal:f,container:w,children:(0,je.jsx)(Me,(0,r.A)({anchorEl:n,disablePortal:f,modifiers:p,ref:t,open:v?!g:u,placement:l,popperOptions:d,popperRef:m},y,{style:(0,r.A)({position:"fixed",top:0,left:0,display:u||!c||v?null:"none"},h),TransitionProps:v?{in:u,onEnter:()=>{b(!1)},onExited:()=>{b(!0)}}:null,children:a}))})}))},36829:(e,t,n)=>{n.d(t,{A:()=>o});var r=n(55429);function o(e){const[t,n]=r.useState(e),o=e||t;return r.useEffect((()=>{null==t&&n(`mui-${Math.round(1e9*Math.random())}`)}),[t]),o}}}]);