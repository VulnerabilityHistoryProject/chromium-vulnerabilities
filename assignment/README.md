# SWEN 331 Vulnerability History Assignment

The purpose of this assignment is to have you see some real vulnerabilities up close. When you see the kinds of vulnerabilities that can happen in real products, in real life, you get a sense for how difficult they can be to find and prevent.

A secondary purpose of this assignment is for you to contribute open source vulnerability history to the academic world. This assignment is also a data curation project that can produce data useful to researchers and developers alike.

Broadly, your responsibilities are to:

  * **Correct** anything that you see is wrong in your CVE data. If we are missing a code review, a bug, or the information is clearly wrong, then correct it!
  * **Investigate** the engineering history of this vulnerability. Not just how it was fixed, but how did it arise? How was it missed? What can we learn from it? And don't just copy-and-paste data - rewrite what you see in plain English so that future students, developers, and researchers can learn from these mistakes.
  * **Curate** the data by attempting to categorize it as carefully as you can. Providing links in your rationale is always welcome - cite your sources! And let future readers dig deep just like you did.

## Round 1. Investigate Vulnerabilities

You will be given 2-3 vulnerabilities to research for the first round. Here's what you need to do:

  1. **Set up a GitHub account.** If do not have a GitHub account, you will need to create one. Please notify us via **_this survey_** what your GitHub username is so that we can trace your GitHub username to your RIT username.
  2. **Fork this repository.** You can read about forking [on GitHub's docs.](https://help.github.com/articles/fork-a-repo/)
  3. **Clone this repository locally** using your favorite Git client.
  4. **Open up your CVE files in a good text editor**. For example, `cves/CVE-2011-3092.yml`. You will be editing [YAML](http://yaml.org) for this assignment, which is a human-friendly JSON-like format that we use for structuring our data. It would be helpful if your text editor support syntax highlighting of YAML files so you can avoid syntax errors. My personal favorites are [Atom](http://atom.io) and [SublimeText](https://www.sublimetext.com/3).
  5. **Read the research notes** that are currently there for the vulnerability, including the questions that need to be filled out.
  6. **Download the Chromium source code repository**. You can do your own `git clone` if you like by going [here](https://chromium.googlesource.com/chromium/src/), or you can download our zip file of the Git repository [from here](#). WARNING: this is a large file and takes a long time to download and unzip!!
  6. **Research the vulnerability** (This step is the bulk of the project!!). Research the following pieces and contribute them to your CVE YAML files. We have notes in the YAML about precisely what we are looking for. Also, we have a detailed example below that Prof. Meneely did himself.
    * CWE identifier.
    * Fix commits. We should have these for you already, but these may need correcting.
    * Description
    * Subsystems
    * Code reviews. We should have these for you already, but these may need correcting.
    * Bugs. We should have these for you already, but these may need correcting.
    * Vulnerability Contributing Commits (VCCs). Essentially the original commit that introduced this code. These are the toughest part. See our example below for how to find these.
    * Unit tested questions
    * Discovered questions
    * Linguistic questions
    * Mistakes questions

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

As an example
