# slurper

Slurper allows you to quickly compose your stories in a text file and import
them into Pivotal Tracker.

Works great with [slurper.vim](http://github.com/adamlowe/vim-slurper)!

## Install

```
$ gem install slurper
```

## Config

Slurper requires a `slurper_config.yml `file in your working directory. This file
contains your Tracker API and story requestor information.

### Example

```yml
# slurper_config.yml

project_id: 1234
token: 123abc123abc123abc
requested_by: Jane Stakeholder
```

The `project_id` tells tracker which project to add your stories to. It can be
found on the project settings or the URL for the project.

The `token` can be found on your personal profile page in Pivotal Tracker.

The `requested_by` field should be the name of your project stakeholder exactly
as it appears in tracker.

## Usage

Create a `stories.slurper` file and compose your stories in the Slurper story
format. In your working directory use the slurp command to import your stories
from the `stories.slurper` file into Pivotal Tracker. Slurper looks for a
`stories.slurper` file in your current directory by default; however, you can
provide an alternate story source file if necessary.

Default

```
$ slurp ~/stories.slurper
```

Also valid

```
$ slurp ~/special_stories.slurper
```

Or even

```
$ slurp ~/mystories.txt
```

### Example Stories

```
/* stories.slurper */

==
story_type:
  chore
name:
  Set Up Staging Environment
description:
  Set up and configure staging environment for approval of stories

labels:
  staging
==
story_type:
  feature
name:
  Campaign Manager Does Something
description:
  In order to get some value
  As a campaign manager
  I want to do something

  - can do something

labels:
  campaign managers
==
story_type:
  release
name:
  Big Release
description:
  This release marks a lot of awesome functionality

labels:
  campaign managers
==
story_type:
  bug
name:
  I did something and nothing happened
description:
  When I do something, another thing is supposed to happen but I see an error screen instead.

labels:
  campaign managers
```

Note: the story source file is whitespace-sensitive. Be sure the value for each
key phrase is indented with two spaces beneath each key phrase. Also, start
each story with a double-equals on its own line.

Your best bet is to leverage
[slurper.vim](http://github.com/adamlowe/vim-slurper) and benefit from its
auto-indenting goodness.

### Example Stories (Advanced)

There are some advanced techniques for formatting your stories beyond the
simple type, name, description and label fields. See below for some examples.

```
/* advanced.slurper */

==
story_type:
  feature
name:
  Make the cart accept coupons on checkout
description:
  When I get to the checkout phase, I want the ability to add an optional coupon code. Use TESTCOUPON to test with.
labels:
  cart,coupon system,checkout
estimate:
  3
requested_by:
  Joe Developer
```

Note: Any field that is supported by the Pivotal Tracker API should work within
reason (i.e. file uploads won't work). To get an idea of the fields available
see Pivotal Tracker's [Example CSV
data](https://www.pivotaltracker.com/help/articles/csv_import_export/#example-csv-data)
documentation.

## Development

1. [Fork](https://help.github.com/articles/fork-a-repo/) it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Please add tests at the same time as new features, and verify they all pass with:

```
$ rake
```

Credit - Wes Gibbs (https://github.com/wesgibbs) thought of and wrote Slurper as a
Ruby script. It was later packaged and released as a gem by his fellow
Rocketeers after using it and finding it extremely handy.

---

### About

[![Hashrocket logo](https://hashrocket.com/hashrocket_logo.svg)](https://hashrocket.com)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fhashrocket%2Fslurper.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fhashrocket%2Fslurper?ref=badge_shield)

Slurper is supported by the team at [Hashrocket, a
multidisciplinary design and development consultancy](https://hashrocket.com). If you'd like to [work with
us](https://hashrocket.com/contact-us/hire-us) or [join our
team](https://hashrocket.com/contact-us/jobs), don't hesitate to get in touch.


## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fhashrocket%2Fslurper.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fhashrocket%2Fslurper?ref=badge_large)