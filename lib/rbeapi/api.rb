#
# Copyright (c) 2014, Arista Networks, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#   Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
#
#   Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
#   Neither the name of Arista Networks nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ARISTA NETWORKS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
require 'rbeapi/eapilib'

module Rbeapi

  module Api

    class Entity

      attr_reader :error
      attr_reader :config
      attr_reader :node

      def self.instance(node)
        new(node)
      end

      def initialize(node, opts = {})
        @node = node
      end

      def config
        return @node.running_config
      end

      def error
        return @node.connection.error
      end

      def get_block(text)
        mdata = /^#{text}$/.match(config)
        return nil unless mdata
        block_start, line_end = mdata.offset(0)

        mdata = /^[^\s]/.match(config, line_end)
        return nil unless mdata

        _, block_end = mdata.offset(0)
        block_end = block_end - block_start

        config[block_start, block_end]
      end

      def configure(commands)
        begin
          @node.config(commands)
          return true
        rescue Rbeapi::Eapilib::CommandError, Rbeapi::Eapilib::ConnectionError
          return false
        end
      end
    end
  end
end
