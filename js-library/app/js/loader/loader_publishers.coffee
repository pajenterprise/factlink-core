window.FactlinkConfig ?= {}
window.FactlinkConfig.api ?= 'https://factlink.com:443'

window.FACTLINK_START_LOADER()

window.FACTLINK.startHighlighting()
window.FACTLINK.startAnnotating()

openId = /#factlink-open-(\d+)/i.exec(window.location.hash)?[1]
scrollToId = openId ? /#factlink-(\d+)/i.exec(window.location.hash)?[1]

if scrollToId?
  window.FACTLINK.scrollTo parseInt(scrollToId)
if openId?
  window.FACTLINK.openFactlinkModal parseInt(openId)