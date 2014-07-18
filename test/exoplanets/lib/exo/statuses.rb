module Exo
  module Statuses
    LABEL_STATUS = {
      # 200 Responses
      success: 200,
      created: 201,
      accepted: 202,
      non_authoritative: 203,
      no_content: 204,
      reset_content: 205,
      partial_content: 206,
      multi_status: 207,
      already_reported: 208,
      im_used: 226,

      # 300 Redirections
      multiple_choices: 300,
      moved_permanently: 301,
      found: 302,
      redirect: 302, # alias of found
      see_other: 303,
      not_modified: 304,
      use_proxy: 305,
      switch_proxy: 306,
      temporary_redirect: 307,
      permanent_redirect: 308,

      # 400 Client Errors
      bad_request: 400,
      unauthorized: 401,
      payment_required: 402,
      forbidden: 403,
      not_found: 404,
      not_allowed: 405,
      not_acceptable: 406,
      authentication_required: 407,
      request_timeout: 408,
      conflict: 409,
      gone: 410,

      # 500 Server Errors
      internal_server_error: 500,
      not_implemented: 501,
      bad_gateway: 502,
      service_unavailable: 503,
      gateway_timeout: 504,
      http_version_not_supported: 505,
    }

    STATUS_LABEL = LABEL_STATUS.invert

    def self.find_status label
      LABEL_STATUS[label]
    end

    def self.find_label status
      STATUS_LABEL[status]
    end
  end
end

