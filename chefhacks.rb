#!/usr/bin/env ruby
#

require 'chef/knife'
require 'chef/knife/search'
require 'fiddle'


class Object
  def unfreeze
    Fiddle::Pointer.new(object_id * 2)[1] &= ~(1 << 3)
  end
end


class Chef
  class Knife
    class Search

      alias_method :orig_read_cli_args, :read_cli_args

      def read_cli_args

        if not config[:query]
            name_args.each do |na|
              if /\brecipe:/.match(na)
                ui.log '[hax] Fixing recipe: to recipes:'
                na.unfreeze
                na.gsub!(/\brecipe:/,'recipes:')
                na.freeze
              end
            end
        end

        # now call original Chef::Knife::Search::read_cli_args
        orig_read_cli_args
      end

    end
  end
end
