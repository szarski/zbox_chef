# sickbeard [![Build Status](https://secure.travis-ci.org/agh-cookbooks/sickbeard.png?branch=master)](http://travis-ci.org/agh-cookbooks/sickbeard)

## Description

Installs the 'sickbeard' software onto a system, and configures the basics for you.

## Usage

### default recipe

If you just include recipe[sickbeard] within the run_list for a role, things should just work -

    {
      name "Base",
      description "All of your systems are belong to Chef",
      "run_list": [
        "recipe[sickbeard]"
      ]
    }

Whatever node['sickbeard']['git_ref'] looks like will be installed on the node. By default this is the latest stable release.
If you want to track the 'develop' branch, or even a specific tag, then you can substitute that in and achieve the desired effect.

In future we will support alternative install styles (node['sickbeard']['install_style']) such as using Apt PPAs.

### Removal

If for some reason you want to stop using the 'sickbeard' recipe, then use recipe[sickbeard::purge].
Any changes the recipe made will be removed from your system, then you can remove from run_list.

## License and Author

Author:: Alex Howells (<alex@howells.me>)

Copyright 2012, Alex Howells

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
