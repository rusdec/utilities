/**
* @param object {name: {string}, value: {string}}
* @return {boolean}
*/
function update_cookie(cookie) {
  var cookies = document.cookie.split(';');
  var cookie_key = find_in_array({
    input_array: cookies,
    pattern: cookie.name
  });

  if (cookie_key === false) {

    return false;
  }

  cookies[cookie_key] = cookie.name.trim()+'='+cookie.value.trim();
  document.cookie = cookies.join(';');

  return true;
}

/**
* @param object {name: {string}, value: {string}}
* @return {boolean}
*/
function set_cookie(cookie) {
  if (get_cookie(cookie.name) === false) {
    document.cookie = cookie.nametrim()+'='+cookie.value.trim()+';';
    if (get_cookie(cookie.name) === false) {

      return false;
    }

  } else {

    return update_cookie(cookie);
  }
}

/**
* @return ({integer} | {boolean}) ключ элемента
* @param object {input_array: {array}, pattern: {string}}
*/
function find_in_array(params) {
  var pattern = new RegExp('^'+params.pattern+'=');
  var find_key = false;

  $(params.input_array).each(function(index, item) {
    item = item.trim();
    if (item.match(pattern)) {
      find_key = index;
    
    return false
  }
});

  return find_key;
}

/**
* @return (object{name: {string}, value: {string}} | {boolean})
* @param {string}
*
* @todo может вместо регекспа просто смотреть cookie_unformatted[0].trim() == cookie_name??
*/
function get_cookie(cookie_name) {
  var cookies = document.cookie.split(';');

  var cookie_key = find_in_array({
    input_array: cookies,
    pattern: cookie_name
  });

  if (cookie_key === false) {

    return cookie_key;
  }

  var cookie_splitted = cookies[cookie_key].split('=');
  var cookie = {
    name: cookie_splitted[0].trim(),
    value: cookie_splitted[1].trim()
  }

  return cookie;
}
