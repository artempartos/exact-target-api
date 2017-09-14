module ET
  class Patch < ET::Constructor
    def initialize(authStub, obj_type, props = nil)
      @results = []
      begin
        authStub.refresh_token
        if props.is_a?(Array)
          obj = { 'Objects' => [] }
          props.each do |p|
            obj['Objects'] << p.merge('@xsi:type' => 'tns:' + obj_type)
          end
        else
          obj = { 'Objects' => props.merge('@xsi:type' => 'tns:' + obj_type) }
        end
        response = authStub.auth.call(:update, message: obj)
      ensure
        super(response)
        if @status
          @status = false if @body[:update_response][:overall_status] != 'OK'
          if !@body[:update_response][:results].is_a?(Hash)
            @results += @body[:update_response][:results]
          else
            @results.push(@body[:update_response][:results])
          end
        end
      end
    end
  end
end
