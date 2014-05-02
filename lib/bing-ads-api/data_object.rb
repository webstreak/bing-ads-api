# -*- encoding : utf-8 -*-

module BingAdsApi

	##
	# Public : Base Class to define Bing API data objects
	# Do not use this class directly, use any of the derived classes
	#
	# Author:: jlopezn@neonline.cl
	#
	class DataObject


		include BingAdsApi::SOAPHasheable

		# Public : Constructor in a ActiveRecord style, with a hash of attributes as input
		#
		# Author:: jlopezn@neonline.cl
		#
		# attributes - Hash with the objects attributes
		def initialize(attributes={})
			attributes.each { |key, val| send("#{key}=", val) if respond_to?("#{key}=") }
		end


		# Public : Specified to string method
		#
		# Author:: jlopezn@neonline.cl
		def to_s
			to_hash.to_s
		end


		# Public: Convert this object's attributes into hash format. It will
		# automatically force the order to place :id first if :id is present.
		#
		# Author:: alex.cavalli@offers.com
		#
		# === Parameters
		# * +keys_case+ - specifies the hash keys case, default 'underscore'
		# ==== keys_case
		# * :camelcase  - CamelCase
		# * :underscore - underscore_case
		def to_hash(keys_case=:underscore)
			hash = super
			elevate_id(hash) if hash["Id"]
			hash
		end

		private


		# Internal: Add an :order! key to the hash pointing to an array of all the
		# other keys in the hash with :id first.
		#
		# Author: alex.cavalli@offers.com
		#
		# === Parameters
		# * +hash+ - the hash to apply an id-elevated order to
		def elevate_id(hash)
			keys = hash.keys
			keys.delete("Id")
			keys.unshift("Id")
			hash[:order!] = keys
		end

	end
end
