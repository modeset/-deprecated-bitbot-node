logger = (message, type = 'info', prefix = '') ->
  prefix = (@logPrefix || '') + prefix
  if type == 'error'
    console.log(prefix, "Error:", message)
  else
    console.log(prefix, message)

module.exports = logger
