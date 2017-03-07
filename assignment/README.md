# SWEN 331 Vulnerability History Assignment

The purpose of this assignment is to have you see some real vulnerabilities up close. When you see the kinds of vulnerabilities that can happen in real products, in real life, you get a sense for how difficult they can be to find and prevent.

A secondary purpose of this assignment is for you to contribute open source vulnerability history to the academic world. This assignment is also a data curation project that can produce data useful to researchers and developers alike.

Broadly, your responsibilities are to:

  * **Correct** anything that you see is wrong in your CVE data. If we are missing a code review, a bug, or the information is clearly wrong, then correct it!
  * **Investigate** the engineering history of this vulnerability. Not just how it was fixed, but how did it arise? How was it missed? What can we learn from it? And don't just copy-and-paste data - rewrite what you see in plain English so that future students, developers, and researchers can learn from these mistakes.
  * **Curate** the data by attempting to categorize it as carefully as you can. Providing links in your rationale is always welcome - cite your sources! And let future readers dig deep just like you did.

## Round 1. Investigate Vulnerabilities

You will be given 2-3 vulnerabilities to research for the first round. Here's what you need to do:

  1. **Set up a GitHub account.** If do not have a GitHub account, you will need to create one. We recommend using a permanent, professional name as this will likely go on your resume.
  2. **Give copyright consent and notify us of your GitHub username**. We would like you to contribute your work to a Creative Commons/MIT Licensed repository to be used in academic resarch. Also, please notify us via [this survey](https://goo.gl/forms/tV6pJ2uaCUoHk1GU2) what your GitHub username is so that we can trace your GitHub username to your RIT username. *NOTE: your contribution to open source is voluntary. We will make similar arrangements to submit your report privately if you do not wish to contribute to this research project. Your grade will not be affected.*
  2. **Fork this repository.** You can read about forking [on GitHub's docs.](https://help.github.com/articles/fork-a-repo/)
  3. **Clone this repository locally** using your favorite Git client.
  4. **Open up your CVE files in a good text editor**. For example, `cves/CVE-2011-3092.yml`. You will be editing [YAML](http://yaml.org) for this assignment, which is a human-friendly JSON-like format that we use for structuring our data. It would be helpful if your text editor support syntax highlighting of YAML files so you can avoid syntax errors. My personal favorites are [Atom](http://atom.io) and [SublimeText](https://www.sublimetext.com/3).
  5. **Read the research notes** that are currently there for the vulnerability, including the questions that need to be filled out.
  6. **Download the Chromium source code repository**. You can do your own `git clone` if you like by going [here](https://chromium.googlesource.com/chromium/src/), or you can download our zip file of the Git repository [from here](#). WARNING: this is a large file and takes a long time to download and unzip!!
  7. **Find the vulnerability fix**. Generally speaking we should have these for you, but you may need to correct and fix the data. Go to the Chromium Git repository that you downloaded and find the fix (`git show` is good for this).
  8. **Find the VCC** (Vulnerability-Contributing Commit). Next, we want to dig into the changes to the files that were affected by this change and attempt to find the commit(s) that introduced this vulnerability in the first place. For this, you will need to follow our example below, but it is essentially making use of `git blame`. Record the VCC commit hash in the data. *This is the most important part of the project in terms of its academic contribution*.
  9. **Find the commits between the VCC and fix**. Using `git log`, get the commits between the VCC(s) and fix(es). You do not need to record these - we will be collecting this automatically in the future based on your VCC. But, these will be the basis for the next step.
  10. **Read**. Begin reading the commit messages, bug reports, and code reviews between the VCC(s) and fix(es). Record any observations, such as major events or linguistic notes as you go. Do your best to get a "big picture" of how this development team works during this time, inferring anything you can about their process, expertise, constraints, etc.
  11. **Record your findings** (This step is the bulk of the project!!). Research the following pieces and contribute them to your CVE YAML files. We have notes in the YAML about precisely what we are looking for. Also, we have a detailed example below that Prof. Meneely did himself.
    * CWE identifier.
    * Fix commits. We should have these for you already, but these may need correcting.
    * Description
    * Subsystems
    * Code reviews. We should have these for you already, but these may need correcting.
    * Bugs. We should have these for you already, but these may need correcting.
    * Vulnerability Contributing Commits (VCCs). Essentially the original commit that introduced this code. These are the toughest part. See our example below for how to find these.
    * Major events
    * Unit tested questions
    * Discovered questions
    * Linguistic questions
    * Mistakes questions
  12. **Submit Pull Request**. See below.

### Round 1 Submission: Pull Request

To submit, you must create a pull request from your repository to ours.

1. **Create a pull requests against the _dev_ branch**. You must name your pull request after the CVEs that you are editing. Write a brief description that will become the commit message. Please create one pull request that edits all of your CVE files.
2. **Your pull request must pass the build tests**. We have all of our YAML files run against some integrity checkers to verify they have the right structure. If your pull request does not pass, then check the details of the build to see which tests failed. You might have broken YAML syntax, or the wrong format for a commit, or some other issue. _You must fix these issues before the Round 1 deadline._
3. **Respond to feedback**. You might get immediate feedback from someone else on the project, even before Round 1 is done. See details below.

Grading:
* 20pts. Build passes on the pull request by the deadline.
* 30pts. Overall quality of research
* 30pts. Clear voice in writing.

## Round 2: Reviewing other Pull Requests

* **Respond to feedback**. You will be getting feedback from your peers, from researchers, from your instructor, and from the TA. You must respond to feedback within 48 hours of getting the feedback. You might be asked to clarify things, provide links, or some other corrections. You will be graded on how well you respond to feedback. You must respond to feedback within 48 hours.
* **Provide editorial feedback.** You will be assigned several CVEs of your peers to review. Be professional and helpful. You will be graded on the quality of your feedback. Your comments should fall into the following categories:

    * _Grammar, Spelling, or Style_: These comments should be trivially correctable. Don't just look for low-hanging fruit here - think about what would make the writing smoother and easier for you to read. For example, "Use active voice in this paragraph instead of passive voice."
    * _Metholology or Investigation comments_: These types of comments concern the content itself (i.e. the assertions about security that the authors are making). For example, "I think this vulnerability could also be an arbitrary code execution concern - can you discuss this possibility too?".

A high-quality comment is insightful, actionable, and constructive. We do not place a number on how many comments you are to supposed give - only on how helpful and insightful they are.

Grading:

* 20pts Quality of feedback given
* 20pts Timely response to feedback

## Example Vulnerability: CVE-2011-3092

Here's an in-depth example done by Prof. Meneely on CVE 2011 3092. You can see his [final YAML file](https://github.com/andymeneely/chromium-vulnerabilities/blob/master/cves/CVE-2011-3092.yml).

### Understanding the Vulnerability

The first thing I did was to read the [CVE entry](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-3092) for the vulnerability to make sure I understood what it was. I then looked up anything I didn't know.

For example, I learned [from Wikipedia](https://en.wikipedia.org/wiki/V8_(JavaScript_engine)) that Google's V8 engine is their Javascript engine and it's the same engine they've had since the beginning of Chrome. V8 is also used in a bunch of other products, such as NodeJS and Electron.

Next, I followed the links from the CVE entry to bug [122337](https://bugs.chromium.org/p/chromium/issues/detail?id=122337). I read the description and comments. I made some notes on how it was discovered (via LangFuzz), and that everyone involved had Google email addresses. I answered those questions in [my YAML](https://github.com/andymeneely/chromium-vulnerabilities/blob/master/cves/CVE-2011-3092.yml) and made some other notes about how it was found.

I also noted that the bug had "Blink" as its "component", but the description said "v8" as the subsystem. I began looking at the differences between the two, and decided to go with v8 as the subsystem. Blink is a massive rendering engine, so v8 would be more specific.

I also started making more notes for my final "mistakes" question report.

### Correcting the fix commit record

In this situation, we did not have a fix that was linked from the CVE. We had some data here from a prior study that we collected automatically, but it turns out it was wrong. So I had to find the fix myself. I cd'ed into my Chromium source tree and ran the following commands.

First I tried:

```
$ git log --grep="CVE-2011-3092"
```

Sometimes you get lucky and they mention the CVE in the commit message. I was not so lucky.

Next I tried searching commit messages for the bug id:

```
$ git log --grep="122337"
```

The commits I got mention a *code review* with that number, but no `BUG=` clause that mentions this fix.

Next I tried searching for "invalid write" in the commit log and scrolled through to look around the dates when this was fixed.

```
$ git log --grep="invalid write"
```

No such luck.

It was at this point that I realized that V8 is actually a separate project for all kinds of things (as I stated above). It actually has its [own repository](https://chromium.googlesource.com/v8/v8/), which I cloned and began my searching there.

I re-ran the above searches with no luck. But, I did notice that person who patched the bug, Erik Corry, was on several commits. So, I examined commits around the time that the vulnerabliity would have been patched (April 12, 2012).

```
$ git log --before=2012-04-15 --stat
```

I used the `--stat` here to show the files that were changed because maybe they would show me some information about what was changed.

Sure enough, I came across this commit:

```
commit b32ff09a49fe4c76827e717f911e5a0066bdad4b
Author: erik.corry@gmail.com <erik.corry@gmail.com@ce2b1a6d-e550-0410-aec6-3dcde31c8c00>
Date:   Fri Apr 13 11:03:22 2012 +0000

    Regexp.rightContext was still not quite right.  Fixed and
    added more tests.
    Review URL: https://chromiumcodereview.appspot.com/10008104

    git-svn-id: http://v8.googlecode.com/svn/branches/bleeding_edge@11312 ce2b1a6d-e550-0410-aec6-3dcde31c8c00

 src/macros.py                    |  9 +++++++++
 src/regexp.js                    | 16 +++++++++-------
 test/mjsunit/regexp-capture-3.js | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 77 insertions(+), 8 deletions(-)
```

I went to the code review URL for this commit and took a look at the test case. The test cases in `regexp-capture-3.js` match almost exactly to the ones found by the fuzzer in the bug. We found our fix! I updated my CVE YAML file with the new fix commit hash (`b32ff09a49fe4c76827e717f911e5a0066bdad4b`).

I also updated my CVE yaml file with an answer to the unit testing question - it's clear that this code was tested prior to this vulnerabliity, but it was also not *fully* tested as they had to add a new test case in fix it.

I should note that this particular fix was rather difficult to find. Hopefully you won't have to do so much work to find your fix, or that the fix we automatically found for you is correct.

### Finding the Vulnerability-Contributing Commit (VCC)

Next, we need to find our VCC. Looking at our commit, we have three files were impacted:

  * src/macros.py
  * src/regexp.js
  * test/mjsunit/regexp-capture-3.js

Given that the third file is clearly a test case, we do not need to trace its history. The vulnerability doesn't *exist* in test cases, only in production code. So we will be tracing our VCCs on the first two files.

Let's take a look at our commit more closely. Using the command line, we can do this:

```
$ git show b32ff09a49fe4c76827e717f911e5a0066bdad4b
```

This gives us this output (I'm abbreviating for just the first file...)

```
commit b32ff09a49fe4c76827e717f911e5a0066bdad4b
Author: erik.corry@gmail.com <erik.corry@gmail.com@ce2b1a6d-e550-0410-aec6-3dcde31c8c00>
Date:   Fri Apr 13 11:03:22 2012 +0000

    Regexp.rightContext was still not quite right.  Fixed and
    added more tests.
    Review URL: https://chromiumcodereview.appspot.com/10008104

    git-svn-id: http://v8.googlecode.com/svn/branches/bleeding_edge@11312 ce2b1a6d-e550-0410-aec6-3dcde31c8c00

diff --git a/src/macros.py b/src/macros.py
index 93287ae..699b368 100644
--- a/src/macros.py
+++ b/src/macros.py
@@ -204,6 +204,15 @@ macro CAPTURE(index) = (3 + (index));
 const CAPTURE0 = 3;
 const CAPTURE1 = 4;

+# For the regexp capture override array.  This has the same
+# format as the arguments to a function called from
+# String.prototype.replace.
+macro OVERRIDE_MATCH(override) = ((override)[0]);
+macro OVERRIDE_POS(override) = ((override)[(override).length - 2]);
+macro OVERRIDE_SUBJECT(override) = ((override)[(override).length - 1]);
+# 1-based so index of 1 returns the first capture
+macro OVERRIDE_CAPTURE(override, index) = ((override)[(index)]);
+
 # PropertyDescriptor return value indices - must match
 # PropertyDescriptorIndices in runtime.cc.
 const IS_ACCESSOR_INDEX = 0;
```

What you see here is a *diff*, or a code difference from before the commit to after the commit. Anywhere you see a `+` sign is code that was added, and `-` means deleted. We have no lines that were deleted in this example.

Now, looking at this code, you can see a few things going on here. First, to fix this vulnerability, we're defining a bunch of new methods. And that's ALL we're doing here. At this point you need to ask yourself: was there a security mistake made here? Or was the mistake made elsewhere and the fix was required to be here? Will we be able to point to a moment in time in the history of this file where a mistake was made?

In this situation, we're going to answer "No". Since the code is effectively a header file, the security mistake was not here. It's really in the logic that needed these extra checks. So we're going to cut off our VCC search for `src/macros.py` and continue to `src/regexp.js`

That being said, header files *can* have vulnerabilities in them. They can have wrong constants, wrong default, poor configuration, and many other problems that are the vulnerability. In fact, we have seen vulnerabilities where the fix was only modifying a constant. So don't ignore header files without looking at your unique situation.

Ok, let's get back to `src/regexp.js`.

```
$ git show b32ff09a49fe4c76827e717f911e5a0066bdad4b
```

...abbreviating to show you what I'm looking at...

```
diff --git a/src/regexp.js b/src/regexp.js
index eb617ea..7bcb612 100644
--- a/src/regexp.js
+++ b/src/regexp.js
@@ -296,7 +296,7 @@ function RegExpToString() {
 // of the last successful match.
 function RegExpGetLastMatch() {
   if (lastMatchInfoOverride !== null) {
-    return lastMatchInfoOverride[0];
+    return OVERRIDE_MATCH(lastMatchInfoOverride);
   }
   var regExpSubject = LAST_SUBJECT(lastMatchInfo);
   return SubString(regExpSubject,
@@ -334,8 +334,8 @@ function RegExpGetLeftContext() {
     subject = LAST_SUBJECT(lastMatchInfo);
   } else {
     var override = lastMatchInfoOverride;
-    start_index = override[override.length - 2];
-    subject = override[override.length - 1];
+    start_index = OVERRIDE_POS(override);
+    subject = OVERRIDE_SUBJECT(override);
   }
   return SubString(subject, 0, start_index);
 }
@@ -349,9 +349,9 @@ function RegExpGetRightContext() {
     subject = LAST_SUBJECT(lastMatchInfo);
   } else {
     var override = lastMatchInfoOverride;
-    subject = override[override.length - 1];
-    var pattern = override[override.length - 3];
-    start_index = override[override.length - 2] + pattern.length;
+    subject = OVERRIDE_SUBJECT(override);
+    var match = OVERRIDE_MATCH(override);
+    start_index = OVERRIDE_POS(override) + match.length;
   }
   return SubString(subject, start_index, subject.length);
 }
@@ -363,7 +363,9 @@ function RegExpGetRightContext() {
 function RegExpMakeCaptureGetter(n) {
   return function() {
     if (lastMatchInfoOverride) {
-      if (n < lastMatchInfoOverride.length - 2) return lastMatchInfoOverride[n];
+      if (n < lastMatchInfoOverride.length - 2) {
+        return OVERRIDE_CAPTURE(lastMatchInfoOverride, n);
+      }
       return '';
     }
     var index = n * 2;
```

This code looks like we had some faulty logic. In particuar, there's a base case check at the beginning of the method that needed correction. Let's figure out what commits contributed this faulty logic. Notice how we have these lines:

```
@@ -296,7 +296,7 @@ function RegExpToString() {
...
@@ -334,8 +334,8 @@ function RegExpGetLeftContext() {
...
@@ -349,9 +349,9 @@ function RegExpGetRightContext() {
...
@@ -363,7 +363,9 @@ function RegExpGetRightContext() {
...
```

These are called *hunks*. The top of each *hunk* tell use where the *diff* begins and ends. In the first hunk, it starts at line 296 on the old file. Now the next few lines are unchanged to show context, so we're really looking for line 299 on that first hunk.

Now let's use a Git tool called `blame` (or if you prefer the nicer word `annotate` - same thing). To see what this looks like, take a look [this link](https://chromium.googlesource.com/v8/v8/+blame/b32ff09a49fe4c76827e717f911e5a0066bdad4b/src/regexp.js). It's the `blame` output on the web version of this code. Git `blame` will go through an entire file and show you the last commit that touched a given line. This lets you figure out how a given chunk of code was originally introduced.

Now, it's important that we look at this *historically*, meaning, we don't want to look at this *today* but *at the time of the vulnerability fix*. So that means we need to include our *fix* commit in our command. Furthermore, we need to look at the "commit just before the fix", otherwise we'll just see our own commit fix in the blame. Git uses the `^` symbol to indicate "the commit before". So our Git command look like this:

```
$ git blame b32ff09a49fe4c76827e717f911e5a0066bdad4b^ -- src/regexp.js
```

We get a ton of output. Sometimes Git blame can be *very slow*. Like, minutes. If that's the case, you can limit your blaming to just the lines you need. See the [git blame docs for -L](https://git-scm.com/docs/git-blame).

Here's an abbreviated output for me:

```
43d26ecc src/regexp-delay.js (christian.plesner.hansen 2008-07-03 15:10:15 +0000 293) // Getters for the static properties lastMatch, lastParen, leftContext, and
43d26ecc src/regexp-delay.js (christian.plesner.hansen 2008-07-03 15:10:15 +0000 294) // rightContext of the RegExp constructor.  The properties are computed based
43d26ecc src/regexp-delay.js (christian.plesner.hansen 2008-07-03 15:10:15 +0000 295) // on the captures array of the last successful match and the subject string
43d26ecc src/regexp-delay.js (christian.plesner.hansen 2008-07-03 15:10:15 +0000 296) // of the last successful match.
43d26ecc src/regexp-delay.js (christian.plesner.hansen 2008-07-03 15:10:15 +0000 297) function RegExpGetLastMatch() {
0adfe842 src/regexp.js       (lrn@chromium.org         2010-04-21 08:33:04 +0000 298)   if (lastMatchInfoOverride !== null) {
0adfe842 src/regexp.js       (lrn@chromium.org         2010-04-21 08:33:04 +0000 299)     return lastMatchInfoOverride[0];
0adfe842 src/regexp.js       (lrn@chromium.org         2010-04-21 08:33:04 +0000 300)   }
912c8eb0 src/regexp-delay.js (erik.corry@gmail.com     2009-03-11 14:00:55 +0000 301)   var regExpSubject = LAST_SUBJECT(lastMatchInfo);
912c8eb0 src/regexp-delay.js (erik.corry@gmail.com     2009-03-11 14:00:55 +0000 302)   return SubString(regExpSubject,
912c8eb0 src/regexp-delay.js (erik.corry@gmail.com     2009-03-11 14:00:55 +0000 303)                    lastMatchInfo[CAPTURE0],
912c8eb0 src/regexp-delay.js (erik.corry@gmail.com     2009-03-11 14:00:55 +0000 304)                    lastMatchInfo[CAPTURE1]);
9da356ee src/regexp-delay.js (ager@chromium.org        2008-10-03 07:14:31 +0000 305) }
```

The few lines that are most relevant to us are 298-300. In commit `0adfe842` (short for `0adfe842a515dd206cb0322d17c05f97244c0e72`), we found that someone wrote that original if-statement and did not check the boundary case for our vulnerability. That's our first VCC.

Well... maybe. Sometimes people fix whitespace in one commit. Correct warnings. Rename stuff. Re-order methods. There's lots of refactoring that can initially *look* like a VCC. So I double-checked that this was a *meaningful* commit using `git show 0adfe842` and found that, yes, it was introducing new logic. So, yes, I'm convinced this is our first VCC.

I recorded `0adfe842a515dd206cb0322d17c05f97244c0e72` as a VCC. You'll notice that this commit occurred nearly two years before the fix came. That's pretty average for vulnerabilities. Mistakes last a long time, even in big systems like Chrome and V8.

At this point I go back to my blame output and find the other commits for the other hunks. I found one and double-checked one other VCC. So my VCCs are:

  * `0adfe842a515dd206cb0322d17c05f97244c0e72`
  * `498b074bd0db2913cf2c9458407c0d340bbcc05e`

I recorded these in my YAML file.

I think it's interesting that these two VCCs were close to each other in time, and they were committed by the same person. I'm going to record that in my final "mistakes" report.

There you go! That's how you find VCCs! It's a tedious process at first, but it speeds up the faster you get at it. Some researchers have [famously automated this process](http://dl.acm.org/citation.cfm?id=1083147), and it's been in [wide use](https://danielcalencar.github.io/journal%20papers/2016/10/07/TSE2016.html)  in the mining software repositories academic research community. The only difference in their approach and ours is that we made some pruning of our search based on our expertise of unit tests, header files, and other coding knowledge we have.

Here are some VCC Guidelines:

  * When in doubt, include the VCC.
  * VCCs don't exist where a header file is just defining new function names.
  * VCCs don't exist in automated tests
  * VCCs don't exist in obvious refatorings. If your `git blame` shows you a commit that was clearly a refactoring, then run `blame` from *before* your refactor commit and keep going.
  * VCCs are often in the original file that committed to the repository

### Looking between VCC and Fix

Next, we need to do some more research on what happened between our two VCCs and fixes. We've determined that the mistake was in `src/regexp.js`, so let's look at what happened between the 2010 dates and 2012 dates with that file.

The `498b074bd0db2913cf2c9458407c0d340bbcc05e` was the earlier commit, so let's just look at that one:

```
$ git log --stat  498b074bd0db2913cf2c9458407c0d340bbcc05e..b32ff09a49fe4c76827e717f911e5a0066bdad4b -- src/regexp.js
```
Some notes:
  * Don't forget the `--` between commits and the file name. It's a parsing thing with Git
  * I used `--stat` again - this will tell me if huge changes hit lots of files at once. Very handy.
  * I limited to one file. I recommend doing one file at a time for this part.

The output gives me ~20 commits over a two-year period. So there was some work, but not tons of work when you think about how much code churn you've created in projects you've worked on. I perused these commits looking for interesting changes to investigate. Here are some interesting commits with my plain English summary of what happened, that I put directly into my YAML:

  * `1729e3c0ddf0c7a0f912ef38355d38afe284bf04`. They worked on changing the responsibilities between the Javascript side and the native side. This is pertinent because that seemed to be the source of the breakdown of our vulnerability: the Javascript assumed the native code had more checks than it did. Following up and reading the code review, they reference "offline" discussions - so this is probably mostly a co-located team within Google.
  * `0f682143d9a50441188ae09cbd669f5389e44597`. They worked with some memory management issues on the native code in this commit. No code review for this change, but it was a very large change on the native side, with some changes on the Javascript side.
  * `e1458503d13cbcc20ae619a1a4d6d0be9cb74bfb`. Tons of code removed for this commit, related to how caching works. No rationale was obvious from the documents, but it was a very significant change code-wise.

With all of this information, I wrote up my final report in the yaml.
