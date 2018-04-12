# Git Internals (35K characters)

## Plumbing and Porcelain
This text is about internal structure of the git - the most popular version control system (VCS).

A git vcs comes with nice user frendly UI. In this chapter of Pro-Git book author explaining what's goin on under the hood. He calls it plumbing of git. The purpose of understainding how git works on a low level is ...


## Git Objects
author starts with the core of git: git objects which are simle key-value data store. There 4 kinds of objects in git: 
1. blob-objects (binary large object)
2. tree-objects
3. commit-objects

then he describes git references. He clarifies that git-vcs core idea is just a graph of commits. Each commit points to tree, each tree points to the (sub)tree or blob.


## Packfiles (easy)
Then author  disclose / illustrate info bout how git compress nearly identical objects with toola called zlib.

## The Refspec & Transfer Protocols
In the next 2 sections author demonstrate sophisticated workflows with git remotes servers. Also he describes how transfer protocols uploading and downloading data via SSH and HTTPS.

7. Maintenance and Data Recovery
Then author gives us some tips:
- how to run garbage collector manually
- how to recover data even after using `git reflog`
- how to remove large objects using `git filter-branch`

8. Environment Variables
Then there's a section with most useful git environment variables

## Summary
Author summarises that:

At this point, you should have a pretty good understanding of what Git does in the background and, to some degree, how it’s implemented. This chapter has covered a number of plumbing commands — commands that are lower level and simpler than the porcelain commands you’ve learned about in the rest of the book. Understanding how Git works at a lower level should make it easier to understand why it’s doing what it’s doing and also to write your own tools and helper scripts to make your specific workflow work for you.

We hope you can use your newfound knowledge of Git internals to implement your own cool application of this technology and feel more comfortable using Git in more advanced ways.

## New Vocab
no new vocab
