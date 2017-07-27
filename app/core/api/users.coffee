fetchJson = require './fetch-json'

module.exports = {
  url: (userID, path) -> if path then "/db/user/#{userID}/#{path}" else "/db/user/#{userID}"
  
  getByHandle: (handle, options) ->
    fetchJson("/db/user/#{handle}", options)
    
  getByIsraelId: (israelId, options) ->
    fetchJson('/db/user', _.assign({}, options, { data: { israelId } }))

  getByEmail: ({ email }, options={}) ->
    fetchJson("/db/user", _.merge {}, options, { data: { email } })
    
  signupWithPassword: ({userID, name, email, password}, options={}) ->
    fetchJson(@url(userID, 'signup-with-password'), _.assign({}, options, {
      method: 'POST'
      json: { name, email, password }
    }))
    .then ->
      window.tracker?.trackEvent 'Finished Signup', category: "Signup", label: 'CodeCombat'

  signupWithFacebook: ({userID, name, email, facebookID}, options={}) ->
    fetchJson(@url(userID, 'signup-with-facebook'), _.assign({}, options, {
      method: 'POST'
      json: { name, email, facebookID, facebookAccessToken: application.facebookHandler.token() }
    }))
    .then ->
      window.tracker?.trackEvent 'Facebook Login', category: "Signup", label: 'Facebook'
      window.tracker?.trackEvent 'Finished Signup', category: "Signup", label: 'Facebook'

  signupWithGPlus: ({userID, name, email, gplusID}, options={}) ->
    fetchJson(@url(userID, 'signup-with-gplus'), _.assign({}, options, {
      method: 'POST'
      json: { name, email, gplusID, gplusAccessToken: application.gplusHandler.token() }
    }))
    .then ->
      window.tracker?.trackEvent 'Google Login', category: "Signup", label: 'GPlus'
      window.tracker?.trackEvent 'Finished Signup', category: "Signup", label: 'GPlus'
      
  put: (user, options={}) ->
    fetchJson(@url(user._id), _.assign({}, options, {
      method: 'PUT'
      json: user
    }))
    
  putIsraelId: ({israelId, userId}, options={}) ->
    fetchJson(@url(userId, 'israel-id'), _.assign({}, options, {
      method: 'PUT'
      json: { israelId }
    }))
    
  resetProgress: (options={}) ->
    store = require('core/store')
    fetchJson(@url(store.state.me._id, 'reset_progress'), _.assign({}, options, {
      method: 'POST'
    }))
}
