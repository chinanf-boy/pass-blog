---
title: 'Water.css 为简单而生的 css 框架'
date: 2019-04-29T21:50:59+08:00
categories: ['css']
tags: ['simple']
description: '为简单文章而生的 css 框架'
css:
  [
    'https://watercss.netlify.com/dist/light.css',

  ]
draft: false
editBtn: false
copyCode: false
anchorLink: false
imageZoom: false
labels: false
---

|  来源 | https://github.com/kognise/water.css  |
|---|---|
| 官方Demo  | https://watercss.netlify.com  |


<h1>Water.css</h1>
<p>
    Water.css is a just-add-css collection of styles to make simple websites like this just a little bit nicer.
    <a href='https://github.com/kognise/water.css'>Get it already!</a>
</p>
<p>
    Now you can write your simple static site with nice semantic html, and Water.css will manage the styling for you.
</p>
<a href='https://www.producthunt.com/posts/water-css?utm_source=badge-featured&utm_medium=badge&utm_souce=badge-water-css' target='_blank'><img id='ph' src='https://api.producthunt.com/widgets/embed-image/v1/top-post-badge.svg?post_id=150490&theme=dark&period=daily' alt='Water.css - Make your tiny website just a little nicer | Product Hunt Embed' style='width: 250px; height: 54px;' width='250px' height='54px' /></a>

<h2>Goals</h2>
<ul>
    <li>Responsive</li>
    <li>Good code quality</li>
    <li>Good browser support</li>
    <li>Small size (&lt; 2kb)</li>
    <li>Beautiful</li>
    <li>No classes</li>
</ul>

<h2>Is it responsive?</h2>
<p>
    <strong>Heck yeah!</strong> It doesn't include any fancy styles so it's easily mobile responsive.
    Just add the famous <a href='https://www.w3schools.com/css/css_rwd_viewport.asp'>responsive viewport tag</a> and you'll be good to go!
</p>
<p>
    In fact, try resizing this page. Everything flows super nicely as you'll see.
</p>
<button id='switch'>Switch theme</button>

<h2>Element demos</h2>
<p>
    This is supposed to be a demo page so we need more elements!
</p>

<h3>Form elements</h3>
<form>
    <label for='email'>Email</label>
    <input type='email' name='email' id='email' placeholder='john.doe@gmail.com'>

<label for='id'>User id (read only)</label>
<input readonly name='id' id='id' value='04D6H89Z'>

<label for='disabled'>Random disabled input</label>
<input disabled name='disabled' id='disabled' placeholder='Because why not?'>

<label for='about'>About me</label>
<textarea name='about' id='about' placeholder='I am a textarea...'></textarea>

<label>Choose a Doe:</label>
<div>
<input type='radio' id='john' name='drone' value='john' checked>
<label for='john'>John Doe</label>
</div>
<div>
<input type='radio' id='jane' name='drone' value='jane' checked>
<label for='jane'>Jane Doe</label>
</div>
<div>
<input type='radio' id='johnny' name='drone' value='johnny' checked>
<label for='johnny'>Johnny Doe</label>
</div>

<br>

<input type='checkbox' name='remember' id='remember' checked>
<label for='remember'>Remember me</label>

<input type='submit'>

</form>

<h3>Code</h3>
<p>
    Below is some code, you can copy it with <kbd>Ctrl-C</kbd>.
    Did you know, <code>alert(1)</code> can show an alert in JavaScript!
</p>
<pre><code>// This logs a message to the console and check out the scrollbar.<br>console.log('Hello, world!')</code></pre>

<h3>Other</h3>
<p>Here's a horizontal rule and image because I don't know where else to put them.</p>
<img src='https://placekitten.com/408/287' alt='Example kitten'>
<hr>

<p>And here's a nicely marked up table!</p>
<table>
    <thead>
    <tr>
        <th>Name</th>
        <th>Quantity</th>
        <th>Price</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td>Godzilla</td>
        <td>2</td>
        <td>$299.99</td>
    </tr>
    <tr>
        <td>Mozilla</td>
        <td>10</td>
        <td>$100,000.00</td>
    </tr>
    <tr>
        <td>Quesadilla</td>
        <td>1</td>
        <td>$2.22</td>
    </tr>
    </tbody>
</table>

<h3>Typography</h3>
<p>
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque dictum hendrerit velit, quis ullamcorper sem congue ac. Quisque id magna rhoncus, sodales massa vel, vestibulum elit. Duis ornare accumsan egestas. Proin maximus lacus interdum leo molestie convallis. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Ut iaculis risus eu felis feugiat, eu mollis neque elementum. Donec interdum, nisl id dignissim iaculis, felis dui aliquet dui, non fermentum velit lectus ac quam. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.
    <strong>This is strong,</strong> this is normal, <b>this is just bold,</b> <em>and this is emphasized!</em> And heck, <a href='/'>here</a>'s a link.
</p>

<blockquote cite='https://developer.mozilla.org/en-US/docs/Web/HTML/Element/blockquote'>
    "The HTML blockquote Element (or HTML Block Quotation Element) indicates
    that the enclosed text is an extended quotation. Usually, this is
    rendered visually by indentation (see
    <a href='https://developer.mozilla.org/en-US/docs/Web/HTML/Element/blockquote#Usage_notes'>Notes</a>
    for how to change it). A URL for the source of the quotation may be given using the
    <code>cite</code> attribute, while a text representation of the source
    can be given using the <code>&ltcite&gt</code> cite element."

    <footer>
    <cite>MDN, "The Block Quotation element"</cite>
    </footer>

</blockquote>

<ul>
    <li>Unordered list item 1</li>
    <li>Unordered list item 2</li>
    <li>Unordered list item 3</li>
</ul>
<ol>
    <li>Ordered list item 1</li>
    <li>Ordered list item 2</li>
    <li>Ordered list item 3</li>
</ol>

<p>
    Addresses are also styled to be <strong>awesome</strong>!
</p>
<address>
    <a href='mailto:john.doe@example.com'>john.doe@example.com</a><br/>
    <a href='tel:778-330-2389'>778-330-2389</a><br/>
    <a href='sms:666-666-6666'>666-666-6666</a><br/>
</address>

<h1>Heading 1</h1>
<h2>Heading 2</h2>
<h3>Heading 3</h3>
<h4>Heading 4</h4>
<h5>Heading 5</h5>
<h6>Heading 6</h6>

<script src="https://watercss.netlify.com/script.js"></script>
