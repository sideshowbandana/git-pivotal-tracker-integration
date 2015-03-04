# Git Pivotal Tracker Integration
# Copyright (c) 2013 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'git-pivotal-tracker-integration/command/base'
require 'git-pivotal-tracker-integration/command/command'
require 'git-pivotal-tracker-integration/util/git'

# The class that encapsulates finishing a Pivotal Tracker Story
class GitPivotalTrackerIntegration::Command::Finish < GitPivotalTrackerIntegration::Command::Base

  # Finishes a Pivotal Tracker story by doing the following steps:
  # * Check that the pending merge will be trivial
  # * Merge the development branch into the root branch
  # * Delete the development branch
  # * Push changes to remote
  #
  # @return [void]
  def run(argument)
    @story = @configuration.story(@project)
    finish_on_tracker
    remove_remote_branch
    # no_complete = argument =~ /--no-complete/

    # GitPivotalTrackerIntegration::Util::Git.trivial_merge?
    # GitPivotalTrackerIntegration::Util::Git.merge(@configuration.story(@project), no_complete)
    # GitPivotalTrackerIntegration::Util::Git.push GitPivotalTrackerIntegration::Util::Git.branch_name
  end

  private
  def finish_on_tracker
    print 'Finishing story on Pivotal Tracker... '
    state = @story.story_type == "chore" ? "accepted" : "finished"
    @story.update(
      :current_state => state
    )
    puts 'OK'
  end

  def remove_remote_branch
    branch_name = GitPivotalTrackerIntegration::Util::Git.branch_name
    print "Removing #{branch_name} from origin... "
    GitPivotalTrackerIntegration::Util::Shell.exec "git push -f --quiet origin :#{branch_name}"
    puts 'OK'
  end

end
