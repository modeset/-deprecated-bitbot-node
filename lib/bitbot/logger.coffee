logger = (message, type = 'info', prefix = '') ->
  prefix = (@logPrefix || '') + prefix
  prefix = "\033[36m#{prefix}"
  if type == 'error'
    console.log(prefix, "\033[31mError:", "#{message}\033[37m")
  else
    console.log(prefix, "\033[37m#{message}\033[37m")

module.exports = logger
