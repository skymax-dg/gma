module JsonWebToken

  attr_reader :headers

  def self.encode(payload, exp = nil)
    payload[:exp] = exp ? exp.to_i : 24.hours.from_now.to_i
    puts "---------- EXP: #{Time.now  + payload[:exp]}"
    jwt_encode(1, payload, secret_key)
  end

  def self.decode(token)
#    body = jwt_decode(token, secret_key)[0]
#    HashWithIndifferentAccess.new body
		 t = jwt_decode(token, secret_key)
		 puts "jwt_decode %s" % [ t.to_s ]
	 	 if t[0] == 'ok'
				puts t[1]
				return t[1]
		 else
				nil
		 end
  rescue
    nil
  end

	def self.jwt_encode(mode, payload, key)
    puts "jwt_encode "+payload.to_s
		case mode
		when 1
			header = { alg: 1, typ: 'mjwt' }
			p1 = Base64.urlsafe_encode64 hash2json(header)
			p2 = Base64.urlsafe_encode64 hash2json(payload)
			# p3 = Base64.urlsafe_encode64(BCrypt::Password.create(p1 + '.' + p2 + key))
			p3 = Base64.urlsafe_encode64(make_digest(p1 + '.'+ p2, key))
			p1 + '.' + p2 + '.' + p3
		else
			payload[:jalg] = 2
			payload[:jtyp] = 'mjwt'
			p2 = Base64.urlsafe_encode64 hash2json(payload)
			p3 = Base64.urlsafe_encode64(make_digest(p2, key))
			p2 + '.' + p3
		end
  end

	def self.jwt_decode(token, key)
			p = token.split('.')
			case p.size
			when 2
				d1 = Base64.urlsafe_decode64 p[0]
				p3 = Base64.urlsafe_encode64(make_digest(p[0], key))

				if p3 == p[1]
					d1h = json2hash(d1)
					if check_expiration?(d1h)
						["token expired", d1, nil, p3]
					else
						["ok", d1h, nil]
					end
				else
					["hash error", d1, nil, p3]
				end
			when 3
				d1 = Base64.urlsafe_decode64 p[0]
				d2 = Base64.urlsafe_decode64 p[1]
				p3 = Base64.urlsafe_encode64(make_digest(p[0] + '.' + p[1], key))
		
				if p3 == p[2]
					d1h = json2hash(d1)
					d2h = json2hash(d2)
					if check_expiration?(d2h)
						["token expired", d1, nil, p3]
					else
						["ok", d2h, nil]
					end
				else
					["hash error", d1, d2, p3]
				end
			else
				["format error"]
			end

	end

	def self.make_digest(ss,key)
			Digest::SHA256.hexdigest(ss + key)
  end

  def self.secret_key
		'e1c08d1dd8eb107e10719e7bff85967112760a238196b63bffb5205fac2a8861b356cad01de1fc5b646ee244ed828e83f0b9f0120b0ce85b8c67fbf43f40462b'
#    Rails.application.secrets&.secret_key_base || Rails.application.credentials&.secret_key_base
  end

	def self.hash2json(h)
		h.to_json
	end

	def self.json2hash(j)
		JSON.parse(j)
	end

	def self.check_expiration?(tk)
		t0 = Time.now.to_i
		t1 = tk["exp"]
		puts "t0 #{t0} t1 #{t1}"
		t0 > t1
	end

	private_class_method :secret_key, :jwt_encode, :jwt_decode, :make_digest
end
