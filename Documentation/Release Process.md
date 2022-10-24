_While tagging a new version of a library and pushing it to CocoaPods is conceptually simple, there are several fine points which must not be forgotten to produce a polished product._

# NYTPhotoViewer Release Process

- Review [the diff between `master` and `develop`](https://github.com/NYTimes/NYTPhotoViewer/compare/master...develop) to determine which part of the version number to increment, in accordance with [semantic versioning](http://semver.org/).
- Update [the Podspec](https://github.com/NYTimes/NYTPhotoViewer/blob/develop/NYTPhotoViewer.podspec) to the new version number.
	- Make this change via a pull request to trigger notifications for those who watch the repository.
- Using [the diff](https://github.com/NYTimes/NYTPhotoViewer/compare/master...develop), [the commit history](https://github.com/NYTimes/NYTPhotoViewer/commits/develop), and any notes about `develop` which may have been written in the `CHANGELOG`, update [`CHANGELOG.md`](https://github.com/NYTimes/NYTPhotoViewer/blob/develop/CHANGELOG.md) with changes in the new version which may affect library users.
	- When reviewing the commit history, searching for “Merge pull request” helps find changes which should appear in [the `CHANGELOG`](https://github.com/NYTimes/NYTPhotoViewer/blob/develop/CHANGELOG.md).
- Update any other documentation which still needs to be updated, given those changes.
- Create a pull request merging [`develop` into `master`](https://github.com/NYTimes/NYTPhotoViewer/compare/master...develop). Merge it yourself, immediately.
- Create a [Github release](https://github.com/NYTimes/NYTPhotoViewer/releases), using the new version number (eg. `1.0.0`) as the tag, and the merge commit into `master` as the target. Copy [the `CHANGELOG`](https://raw.githubusercontent.com/NYTimes/NYTPhotoViewer/develop/CHANGELOG.md)’s Markdown content for this release into the Github release.
- Push the new Podspec to Cocoapods Trunk: `pod trunk push NYTPhotoViewer.podspec`
	- Ensure your local clone is up-to-date before this push.

## CocoaPods Trunk Setup

Before you can use this process to push a release to CocoaPods:

- Set up a CocoaPods Trunk account on your machine: [Getting setup with Trunk/Getting started](https://guides.cocoapods.org/making/getting-setup-with-trunk.html#getting-started)
- Become an owner for [NYTPhotoViewer](https://cocoapods.org/pods/NYTPhotoViewer). A current owner will need to run `pod trunk add-owner NYTPhotoViewer your.email@nytimes.com`
