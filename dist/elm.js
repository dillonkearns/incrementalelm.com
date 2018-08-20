(function(scope){
'use strict';

function F(arity, fun, wrapper) {
  wrapper.a = arity;
  wrapper.f = fun;
  return wrapper;
}

function F2(fun) {
  return F(2, fun, function(a) { return function(b) { return fun(a,b); }; })
}
function F3(fun) {
  return F(3, fun, function(a) {
    return function(b) { return function(c) { return fun(a, b, c); }; };
  });
}
function F4(fun) {
  return F(4, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return fun(a, b, c, d); }; }; };
  });
}
function F5(fun) {
  return F(5, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return fun(a, b, c, d, e); }; }; }; };
  });
}
function F6(fun) {
  return F(6, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return fun(a, b, c, d, e, f); }; }; }; }; };
  });
}
function F7(fun) {
  return F(7, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return fun(a, b, c, d, e, f, g); }; }; }; }; }; };
  });
}
function F8(fun) {
  return F(8, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) {
    return fun(a, b, c, d, e, f, g, h); }; }; }; }; }; }; };
  });
}
function F9(fun) {
  return F(9, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) { return function(i) {
    return fun(a, b, c, d, e, f, g, h, i); }; }; }; }; }; }; }; };
  });
}

function A2(fun, a, b) {
  return fun.a === 2 ? fun.f(a, b) : fun(a)(b);
}
function A3(fun, a, b, c) {
  return fun.a === 3 ? fun.f(a, b, c) : fun(a)(b)(c);
}
function A4(fun, a, b, c, d) {
  return fun.a === 4 ? fun.f(a, b, c, d) : fun(a)(b)(c)(d);
}
function A5(fun, a, b, c, d, e) {
  return fun.a === 5 ? fun.f(a, b, c, d, e) : fun(a)(b)(c)(d)(e);
}
function A6(fun, a, b, c, d, e, f) {
  return fun.a === 6 ? fun.f(a, b, c, d, e, f) : fun(a)(b)(c)(d)(e)(f);
}
function A7(fun, a, b, c, d, e, f, g) {
  return fun.a === 7 ? fun.f(a, b, c, d, e, f, g) : fun(a)(b)(c)(d)(e)(f)(g);
}
function A8(fun, a, b, c, d, e, f, g, h) {
  return fun.a === 8 ? fun.f(a, b, c, d, e, f, g, h) : fun(a)(b)(c)(d)(e)(f)(g)(h);
}
function A9(fun, a, b, c, d, e, f, g, h, i) {
  return fun.a === 9 ? fun.f(a, b, c, d, e, f, g, h, i) : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
}




var _JsArray_empty = [];

function _JsArray_singleton(value)
{
    return [value];
}

function _JsArray_length(array)
{
    return array.length;
}

var _JsArray_initialize = F3(function(size, offset, func)
{
    var result = new Array(size);

    for (var i = 0; i < size; i++)
    {
        result[i] = func(offset + i);
    }

    return result;
});

var _JsArray_initializeFromList = F2(function (max, ls)
{
    var result = new Array(max);

    for (var i = 0; i < max && ls.b; i++)
    {
        result[i] = ls.a;
        ls = ls.b;
    }

    result.length = i;
    return _Utils_Tuple2(result, ls);
});

var _JsArray_unsafeGet = F2(function(index, array)
{
    return array[index];
});

var _JsArray_unsafeSet = F3(function(index, value, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[index] = value;
    return result;
});

var _JsArray_push = F2(function(value, array)
{
    var length = array.length;
    var result = new Array(length + 1);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[length] = value;
    return result;
});

var _JsArray_foldl = F3(function(func, acc, array)
{
    var length = array.length;

    for (var i = 0; i < length; i++)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_foldr = F3(function(func, acc, array)
{
    for (var i = array.length - 1; i >= 0; i--)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_map = F2(function(func, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = func(array[i]);
    }

    return result;
});

var _JsArray_indexedMap = F3(function(func, offset, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = A2(func, offset + i, array[i]);
    }

    return result;
});

var _JsArray_slice = F3(function(from, to, array)
{
    return array.slice(from, to);
});

var _JsArray_appendN = F3(function(n, dest, source)
{
    var destLen = dest.length;
    var itemsToCopy = n - destLen;

    if (itemsToCopy > source.length)
    {
        itemsToCopy = source.length;
    }

    var size = destLen + itemsToCopy;
    var result = new Array(size);

    for (var i = 0; i < destLen; i++)
    {
        result[i] = dest[i];
    }

    for (var i = 0; i < itemsToCopy; i++)
    {
        result[i + destLen] = source[i];
    }

    return result;
});



// LOG

var _Debug_log = F2(function(tag, value)
{
	return value;
});

var _Debug_log_UNUSED = F2(function(tag, value)
{
	console.log(tag + ': ' + _Debug_toString(value));
	return value;
});


// TODOS

function _Debug_todo(moduleName, region)
{
	return function(message) {
		_Debug_crash(8, moduleName, region, message);
	};
}

function _Debug_todoCase(moduleName, region, value)
{
	return function(message) {
		_Debug_crash(9, moduleName, region, value, message);
	};
}


// TO STRING

function _Debug_toString(value)
{
	return '<internals>';
}

function _Debug_toString_UNUSED(value)
{
	return _Debug_toAnsiString(false, value);
}

function _Debug_toAnsiString(ansi, value)
{
	if (typeof value === 'function')
	{
		return _Debug_internalColor(ansi, '<function>');
	}

	if (typeof value === 'boolean')
	{
		return _Debug_ctorColor(ansi, value ? 'True' : 'False');
	}

	if (typeof value === 'number')
	{
		return _Debug_numberColor(ansi, value + '');
	}

	if (value instanceof String)
	{
		return _Debug_charColor(ansi, "'" + _Debug_addSlashes(value, true) + "'");
	}

	if (typeof value === 'string')
	{
		return _Debug_stringColor(ansi, '"' + _Debug_addSlashes(value, false) + '"');
	}

	if (typeof value === 'object' && '$' in value)
	{
		var tag = value.$;

		if (typeof tag === 'number')
		{
			return _Debug_internalColor(ansi, '<internals>');
		}

		if (tag[0] === '#')
		{
			var output = [];
			for (var k in value)
			{
				if (k === '$') continue;
				output.push(_Debug_toAnsiString(ansi, value[k]));
			}
			return '(' + output.join(',') + ')';
		}

		if (tag === 'Set_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Set')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, elm$core$Set$toList(value));
		}

		if (tag === 'RBNode_elm_builtin' || tag === 'RBEmpty_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Dict')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, elm$core$Dict$toList(value));
		}

		if (tag === 'Array_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Array')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, elm$core$Array$toList(value));
		}

		if (tag === '::' || tag === '[]')
		{
			var output = '[';

			value.b && (output += _Debug_toAnsiString(ansi, value.a), value = value.b)

			for (; value.b; value = value.b) // WHILE_CONS
			{
				output += ',' + _Debug_toAnsiString(ansi, value.a);
			}
			return output + ']';
		}

		var output = '';
		for (var i in value)
		{
			if (i === '$') continue;
			var str = _Debug_toAnsiString(ansi, value[i]);
			var c0 = str[0];
			var parenless = c0 === '{' || c0 === '(' || c0 === '[' || c0 === '<' || c0 === '"' || str.indexOf(' ') < 0;
			output += ' ' + (parenless ? str : '(' + str + ')');
		}
		return _Debug_ctorColor(ansi, tag) + output;
	}

	if (typeof value === 'object')
	{
		var output = [];
		for (var key in value)
		{
			var field = key[0] === '_' ? key.slice(1) : key;
			output.push(_Debug_fadeColor(ansi, field) + ' = ' + _Debug_toAnsiString(ansi, value[key]));
		}
		if (output.length === 0)
		{
			return '{}';
		}
		return '{ ' + output.join(', ') + ' }';
	}

	return _Debug_internalColor(ansi, '<internals>');
}

function _Debug_addSlashes(str, isChar)
{
	var s = str
		.replace(/\\/g, '\\\\')
		.replace(/\n/g, '\\n')
		.replace(/\t/g, '\\t')
		.replace(/\r/g, '\\r')
		.replace(/\v/g, '\\v')
		.replace(/\0/g, '\\0');

	if (isChar)
	{
		return s.replace(/\'/g, '\\\'');
	}
	else
	{
		return s.replace(/\"/g, '\\"');
	}
}

function _Debug_ctorColor(ansi, string)
{
	return ansi ? '\x1b[96m' + string + '\x1b[0m' : string;
}

function _Debug_numberColor(ansi, string)
{
	return ansi ? '\x1b[95m' + string + '\x1b[0m' : string;
}

function _Debug_stringColor(ansi, string)
{
	return ansi ? '\x1b[93m' + string + '\x1b[0m' : string;
}

function _Debug_charColor(ansi, string)
{
	return ansi ? '\x1b[92m' + string + '\x1b[0m' : string;
}

function _Debug_fadeColor(ansi, string)
{
	return ansi ? '\x1b[37m' + string + '\x1b[0m' : string;
}

function _Debug_internalColor(ansi, string)
{
	return ansi ? '\x1b[94m' + string + '\x1b[0m' : string;
}



// CRASH


function _Debug_crash(identifier)
{
	throw new Error('https://github.com/elm/core/blob/1.0.0/hints/' + identifier + '.md');
}


function _Debug_crash_UNUSED(identifier, fact1, fact2, fact3, fact4)
{
	switch(identifier)
	{
		case 0:
			throw new Error('What node should I take over? In JavaScript I need something like:\n\n    Elm.Main.init({\n        node: document.getElementById("elm-node")\n    })\n\nYou need to do this with any Browser.sandbox or Browser.element program.');

		case 1:
			throw new Error('Browser.application programs cannot handle URLs like this:\n\n    ' + document.location.href + '\n\nWhat is the root? The root of your file system? Try looking at this program with `elm reactor` or some other server.');

		case 2:
			var message = fact1;
			throw new Error('Problem with the flags given to your Elm program on initialization.\n\n' + message);

		case 3:
			var portName = fact1;
			throw new Error('There can only be one port named `' + portName + '`, but your program has multiple.');

		case 4:
			var portName = fact1;
			var problem = fact2;
			throw new Error('Trying to send an unexpected type of value through port `' + portName + '`:\n' + problem);

		case 5:
			throw new Error('Trying to use `(==)` on functions.\nThere is no way to know if functions are "the same" in the Elm sense.\nRead more about this at https://package.elm-lang.org/packages/elm/core/latest/Basics#== which describes why it is this way and what the better version will look like.');

		case 6:
			var moduleName = fact1;
			throw new Error('Your page is loading multiple Elm scripts with a module named ' + moduleName + '. Maybe a duplicate script is getting loaded accidentally? If not, rename one of them so I know which is which!');

		case 8:
			var moduleName = fact1;
			var region = fact2;
			var message = fact3;
			throw new Error('TODO in module `' + moduleName + '` ' + _Debug_regionToString(region) + '\n\n' + message);

		case 9:
			var moduleName = fact1;
			var region = fact2;
			var value = fact3;
			var message = fact4;
			throw new Error(
				'TODO in module `' + moduleName + '` from the `case` expression '
				+ _Debug_regionToString(region) + '\n\nIt received the following value:\n\n    '
				+ _Debug_toString(value).replace('\n', '\n    ')
				+ '\n\nBut the branch that handles it says:\n\n    ' + message.replace('\n', '\n    ')
			);

		case 10:
			throw new Error('Bug in https://github.com/elm/virtual-dom/issues');

		case 11:
			throw new Error('Cannot perform mod 0. Division by zero error.');
	}
}

function _Debug_regionToString(region)
{
	if (region.bN.ap === region.bk.ap)
	{
		return 'on line ' + region.bN.ap;
	}
	return 'on lines ' + region.bN.ap + ' through ' + region.bk.ap;
}



// EQUALITY

function _Utils_eq(x, y)
{
	for (
		var pair, stack = [], isEqual = _Utils_eqHelp(x, y, 0, stack);
		isEqual && (pair = stack.pop());
		isEqual = _Utils_eqHelp(pair.a, pair.b, 0, stack)
		)
	{}

	return isEqual;
}

function _Utils_eqHelp(x, y, depth, stack)
{
	if (depth > 100)
	{
		stack.push(_Utils_Tuple2(x,y));
		return true;
	}

	if (x === y)
	{
		return true;
	}

	if (typeof x !== 'object' || x === null || y === null)
	{
		typeof x === 'function' && _Debug_crash(5);
		return false;
	}

	/**_UNUSED/
	if (x.$ === 'Set_elm_builtin')
	{
		x = elm$core$Set$toList(x);
		y = elm$core$Set$toList(y);
	}
	if (x.$ === 'RBNode_elm_builtin' || x.$ === 'RBEmpty_elm_builtin')
	{
		x = elm$core$Dict$toList(x);
		y = elm$core$Dict$toList(y);
	}
	//*/

	/**/
	if (x.$ < 0)
	{
		x = elm$core$Dict$toList(x);
		y = elm$core$Dict$toList(y);
	}
	//*/

	for (var key in x)
	{
		if (!_Utils_eqHelp(x[key], y[key], depth + 1, stack))
		{
			return false;
		}
	}
	return true;
}

var _Utils_equal = F2(_Utils_eq);
var _Utils_notEqual = F2(function(a, b) { return !_Utils_eq(a,b); });



// COMPARISONS

// Code in Generate/JavaScript.hs, Basics.js, and List.js depends on
// the particular integer values assigned to LT, EQ, and GT.

function _Utils_cmp(x, y, ord)
{
	if (typeof x !== 'object')
	{
		return x === y ? /*EQ*/ 0 : x < y ? /*LT*/ -1 : /*GT*/ 1;
	}

	/**_UNUSED/
	if (x instanceof String)
	{
		var a = x.valueOf();
		var b = y.valueOf();
		return a === b ? 0 : a < b ? -1 : 1;
	}
	//*/

	/**/
	if (!x.$)
	//*/
	/**_UNUSED/
	if (x.$[0] === '#')
	//*/
	{
		return (ord = _Utils_cmp(x.a, y.a))
			? ord
			: (ord = _Utils_cmp(x.b, y.b))
				? ord
				: _Utils_cmp(x.c, y.c);
	}

	// traverse conses until end of a list or a mismatch
	for (; x.b && y.b && !(ord = _Utils_cmp(x.a, y.a)); x = x.b, y = y.b) {} // WHILE_CONSES
	return ord || (x.b ? /*GT*/ 1 : y.b ? /*LT*/ -1 : /*EQ*/ 0);
}

var _Utils_lt = F2(function(a, b) { return _Utils_cmp(a, b) < 0; });
var _Utils_le = F2(function(a, b) { return _Utils_cmp(a, b) < 1; });
var _Utils_gt = F2(function(a, b) { return _Utils_cmp(a, b) > 0; });
var _Utils_ge = F2(function(a, b) { return _Utils_cmp(a, b) >= 0; });

var _Utils_compare = F2(function(x, y)
{
	var n = _Utils_cmp(x, y);
	return n < 0 ? elm$core$Basics$LT : n ? elm$core$Basics$GT : elm$core$Basics$EQ;
});


// COMMON VALUES

var _Utils_Tuple0 = 0;
var _Utils_Tuple0_UNUSED = { $: '#0' };

function _Utils_Tuple2(a, b) { return { a: a, b: b }; }
function _Utils_Tuple2_UNUSED(a, b) { return { $: '#2', a: a, b: b }; }

function _Utils_Tuple3(a, b, c) { return { a: a, b: b, c: c }; }
function _Utils_Tuple3_UNUSED(a, b, c) { return { $: '#3', a: a, b: b, c: c }; }

function _Utils_chr(c) { return c; }
function _Utils_chr_UNUSED(c) { return new String(c); }


// RECORDS

function _Utils_update(oldRecord, updatedFields)
{
	var newRecord = {};

	for (var key in oldRecord)
	{
		newRecord[key] = oldRecord[key];
	}

	for (var key in updatedFields)
	{
		newRecord[key] = updatedFields[key];
	}

	return newRecord;
}


// APPEND

var _Utils_append = F2(_Utils_ap);

function _Utils_ap(xs, ys)
{
	// append Strings
	if (typeof xs === 'string')
	{
		return xs + ys;
	}

	// append Lists
	if (!xs.b)
	{
		return ys;
	}
	var root = _List_Cons(xs.a, ys);
	xs = xs.b
	for (var curr = root; xs.b; xs = xs.b) // WHILE_CONS
	{
		curr = curr.b = _List_Cons(xs.a, ys);
	}
	return root;
}



var _List_Nil = { $: 0 };
var _List_Nil_UNUSED = { $: '[]' };

function _List_Cons(hd, tl) { return { $: 1, a: hd, b: tl }; }
function _List_Cons_UNUSED(hd, tl) { return { $: '::', a: hd, b: tl }; }


var _List_cons = F2(_List_Cons);

function _List_fromArray(arr)
{
	var out = _List_Nil;
	for (var i = arr.length; i--; )
	{
		out = _List_Cons(arr[i], out);
	}
	return out;
}

function _List_toArray(xs)
{
	for (var out = []; xs.b; xs = xs.b) // WHILE_CONS
	{
		out.push(xs.a);
	}
	return out;
}

var _List_map2 = F3(function(f, xs, ys)
{
	for (var arr = []; xs.b && ys.b; xs = xs.b, ys = ys.b) // WHILE_CONSES
	{
		arr.push(A2(f, xs.a, ys.a));
	}
	return _List_fromArray(arr);
});

var _List_map3 = F4(function(f, xs, ys, zs)
{
	for (var arr = []; xs.b && ys.b && zs.b; xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A3(f, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map4 = F5(function(f, ws, xs, ys, zs)
{
	for (var arr = []; ws.b && xs.b && ys.b && zs.b; ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A4(f, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map5 = F6(function(f, vs, ws, xs, ys, zs)
{
	for (var arr = []; vs.b && ws.b && xs.b && ys.b && zs.b; vs = vs.b, ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A5(f, vs.a, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_sortBy = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		return _Utils_cmp(f(a), f(b));
	}));
});

var _List_sortWith = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		var ord = A2(f, a, b);
		return ord === elm$core$Basics$EQ ? 0 : ord === elm$core$Basics$LT ? -1 : 1;
	}));
});



// MATH

var _Basics_add = F2(function(a, b) { return a + b; });
var _Basics_sub = F2(function(a, b) { return a - b; });
var _Basics_mul = F2(function(a, b) { return a * b; });
var _Basics_fdiv = F2(function(a, b) { return a / b; });
var _Basics_idiv = F2(function(a, b) { return (a / b) | 0; });
var _Basics_pow = F2(Math.pow);

var _Basics_remainderBy = F2(function(b, a) { return a % b; });

// https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/divmodnote-letter.pdf
var _Basics_modBy = F2(function(modulus, x)
{
	var answer = x % modulus;
	return modulus === 0
		? _Debug_crash(11)
		:
	((answer > 0 && modulus < 0) || (answer < 0 && modulus > 0))
		? answer + modulus
		: answer;
});


// TRIGONOMETRY

var _Basics_pi = Math.PI;
var _Basics_e = Math.E;
var _Basics_cos = Math.cos;
var _Basics_sin = Math.sin;
var _Basics_tan = Math.tan;
var _Basics_acos = Math.acos;
var _Basics_asin = Math.asin;
var _Basics_atan = Math.atan;
var _Basics_atan2 = F2(Math.atan2);


// MORE MATH

function _Basics_toFloat(x) { return x; }
function _Basics_truncate(n) { return n | 0; }
function _Basics_isInfinite(n) { return n === Infinity || n === -Infinity; }

var _Basics_ceiling = Math.ceil;
var _Basics_floor = Math.floor;
var _Basics_round = Math.round;
var _Basics_sqrt = Math.sqrt;
var _Basics_log = Math.log;
var _Basics_isNaN = isNaN;


// BOOLEANS

function _Basics_not(bool) { return !bool; }
var _Basics_and = F2(function(a, b) { return a && b; });
var _Basics_or  = F2(function(a, b) { return a || b; });
var _Basics_xor = F2(function(a, b) { return a !== b; });



// TASKS

function _Scheduler_succeed(value)
{
	return {
		$: 0,
		a: value
	};
}

function _Scheduler_fail(error)
{
	return {
		$: 1,
		a: error
	};
}

function _Scheduler_binding(callback)
{
	return {
		$: 2,
		b: callback,
		c: null
	};
}

var _Scheduler_andThen = F2(function(callback, task)
{
	return {
		$: 3,
		b: callback,
		d: task
	};
});

var _Scheduler_onError = F2(function(callback, task)
{
	return {
		$: 4,
		b: callback,
		d: task
	};
});

function _Scheduler_receive(callback)
{
	return {
		$: 5,
		b: callback
	};
}


// PROCESSES

var _Scheduler_guid = 0;

function _Scheduler_rawSpawn(task)
{
	var proc = {
		$: 0,
		e: _Scheduler_guid++,
		f: task,
		g: null,
		h: []
	};

	_Scheduler_enqueue(proc);

	return proc;
}

function _Scheduler_spawn(task)
{
	return _Scheduler_binding(function(callback) {
		callback(_Scheduler_succeed(_Scheduler_rawSpawn(task)));
	});
}

function _Scheduler_rawSend(proc, msg)
{
	proc.h.push(msg);
	_Scheduler_enqueue(proc);
}

var _Scheduler_send = F2(function(proc, msg)
{
	return _Scheduler_binding(function(callback) {
		_Scheduler_rawSend(proc, msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});

function _Scheduler_kill(proc)
{
	return _Scheduler_binding(function(callback) {
		var task = proc.f;
		if (task.$ === 2 && task.c)
		{
			task.c();
		}

		proc.f = null;

		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
}


/* STEP PROCESSES

type alias Process =
  { $ : tag
  , id : unique_id
  , root : Task
  , stack : null | { $: SUCCEED | FAIL, a: callback, b: stack }
  , mailbox : [msg]
  }

*/


var _Scheduler_working = false;
var _Scheduler_queue = [];


function _Scheduler_enqueue(proc)
{
	_Scheduler_queue.push(proc);
	if (_Scheduler_working)
	{
		return;
	}
	_Scheduler_working = true;
	while (proc = _Scheduler_queue.shift())
	{
		_Scheduler_step(proc);
	}
	_Scheduler_working = false;
}


function _Scheduler_step(proc)
{
	while (proc.f)
	{
		var rootTag = proc.f.$;
		if (rootTag === 0 || rootTag === 1)
		{
			while (proc.g && proc.g.$ !== rootTag)
			{
				proc.g = proc.g.i;
			}
			if (!proc.g)
			{
				return;
			}
			proc.f = proc.g.b(proc.f.a);
			proc.g = proc.g.i;
		}
		else if (rootTag === 2)
		{
			proc.f.c = proc.f.b(function(newRoot) {
				proc.f = newRoot;
				_Scheduler_enqueue(proc);
			});
			return;
		}
		else if (rootTag === 5)
		{
			if (proc.h.length === 0)
			{
				return;
			}
			proc.f = proc.f.b(proc.h.shift());
		}
		else // if (rootTag === 3 || rootTag === 4)
		{
			proc.g = {
				$: rootTag === 3 ? 0 : 1,
				b: proc.f.b,
				i: proc.g
			};
			proc.f = proc.f.d;
		}
	}
}



// CORE DECODERS

function _Json_succeed(msg)
{
	return {
		$: 0,
		a: msg
	};
}

function _Json_fail(msg)
{
	return {
		$: 1,
		a: msg
	};
}

var _Json_decodeInt = { $: 2 };
var _Json_decodeBool = { $: 3 };
var _Json_decodeFloat = { $: 4 };
var _Json_decodeValue = { $: 5 };
var _Json_decodeString = { $: 6 };

function _Json_decodeList(decoder) { return { $: 7, b: decoder }; }
function _Json_decodeArray(decoder) { return { $: 8, b: decoder }; }

function _Json_decodeNull(value) { return { $: 9, c: value }; }

var _Json_decodeField = F2(function(field, decoder)
{
	return {
		$: 10,
		d: field,
		b: decoder
	};
});

var _Json_decodeIndex = F2(function(index, decoder)
{
	return {
		$: 11,
		e: index,
		b: decoder
	};
});

function _Json_decodeKeyValuePairs(decoder)
{
	return {
		$: 12,
		b: decoder
	};
}

function _Json_mapMany(f, decoders)
{
	return {
		$: 13,
		f: f,
		g: decoders
	};
}

var _Json_andThen = F2(function(callback, decoder)
{
	return {
		$: 14,
		b: decoder,
		h: callback
	};
});

function _Json_oneOf(decoders)
{
	return {
		$: 15,
		g: decoders
	};
}


// DECODING OBJECTS

var _Json_map1 = F2(function(f, d1)
{
	return _Json_mapMany(f, [d1]);
});

var _Json_map2 = F3(function(f, d1, d2)
{
	return _Json_mapMany(f, [d1, d2]);
});

var _Json_map3 = F4(function(f, d1, d2, d3)
{
	return _Json_mapMany(f, [d1, d2, d3]);
});

var _Json_map4 = F5(function(f, d1, d2, d3, d4)
{
	return _Json_mapMany(f, [d1, d2, d3, d4]);
});

var _Json_map5 = F6(function(f, d1, d2, d3, d4, d5)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5]);
});

var _Json_map6 = F7(function(f, d1, d2, d3, d4, d5, d6)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6]);
});

var _Json_map7 = F8(function(f, d1, d2, d3, d4, d5, d6, d7)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7]);
});

var _Json_map8 = F9(function(f, d1, d2, d3, d4, d5, d6, d7, d8)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7, d8]);
});


// DECODE

var _Json_runOnString = F2(function(decoder, string)
{
	try
	{
		var value = JSON.parse(string);
		return _Json_runHelp(decoder, value);
	}
	catch (e)
	{
		return elm$core$Result$Err(A2(elm$json$Json$Decode$Failure, 'This is not valid JSON! ' + e.message, _Json_wrap(string)));
	}
});

var _Json_run = F2(function(decoder, value)
{
	return _Json_runHelp(decoder, _Json_unwrap(value));
});

function _Json_runHelp(decoder, value)
{
	switch (decoder.$)
	{
		case 3:
			return (typeof value === 'boolean')
				? elm$core$Result$Ok(value)
				: _Json_expecting('a BOOL', value);

		case 2:
			if (typeof value !== 'number') {
				return _Json_expecting('an INT', value);
			}

			if (-2147483647 < value && value < 2147483647 && (value | 0) === value) {
				return elm$core$Result$Ok(value);
			}

			if (isFinite(value) && !(value % 1)) {
				return elm$core$Result$Ok(value);
			}

			return _Json_expecting('an INT', value);

		case 4:
			return (typeof value === 'number')
				? elm$core$Result$Ok(value)
				: _Json_expecting('a FLOAT', value);

		case 6:
			return (typeof value === 'string')
				? elm$core$Result$Ok(value)
				: (value instanceof String)
					? elm$core$Result$Ok(value + '')
					: _Json_expecting('a STRING', value);

		case 9:
			return (value === null)
				? elm$core$Result$Ok(decoder.c)
				: _Json_expecting('null', value);

		case 5:
			return elm$core$Result$Ok(_Json_wrap(value));

		case 7:
			if (!Array.isArray(value))
			{
				return _Json_expecting('a LIST', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _List_fromArray);

		case 8:
			if (!Array.isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _Json_toElmArray);

		case 10:
			var field = decoder.d;
			if (typeof value !== 'object' || value === null || !(field in value))
			{
				return _Json_expecting('an OBJECT with a field named `' + field + '`', value);
			}
			var result = _Json_runHelp(decoder.b, value[field]);
			return (elm$core$Result$isOk(result)) ? result : elm$core$Result$Err(A2(elm$json$Json$Decode$Field, field, result.a));

		case 11:
			var index = decoder.e;
			if (!Array.isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			if (index >= value.length)
			{
				return _Json_expecting('a LONGER array. Need index ' + index + ' but only see ' + value.length + ' entries', value);
			}
			var result = _Json_runHelp(decoder.b, value[index]);
			return (elm$core$Result$isOk(result)) ? result : elm$core$Result$Err(A2(elm$json$Json$Decode$Index, index, result.a));

		case 12:
			if (typeof value !== 'object' || value === null || Array.isArray(value))
			{
				return _Json_expecting('an OBJECT', value);
			}

			var keyValuePairs = _List_Nil;
			// TODO test perf of Object.keys and switch when support is good enough
			for (var key in value)
			{
				if (value.hasOwnProperty(key))
				{
					var result = _Json_runHelp(decoder.b, value[key]);
					if (!elm$core$Result$isOk(result))
					{
						return elm$core$Result$Err(A2(elm$json$Json$Decode$Field, key, result.a));
					}
					keyValuePairs = _List_Cons(_Utils_Tuple2(key, result.a), keyValuePairs);
				}
			}
			return elm$core$Result$Ok(elm$core$List$reverse(keyValuePairs));

		case 13:
			var answer = decoder.f;
			var decoders = decoder.g;
			for (var i = 0; i < decoders.length; i++)
			{
				var result = _Json_runHelp(decoders[i], value);
				if (!elm$core$Result$isOk(result))
				{
					return result;
				}
				answer = answer(result.a);
			}
			return elm$core$Result$Ok(answer);

		case 14:
			var result = _Json_runHelp(decoder.b, value);
			return (!elm$core$Result$isOk(result))
				? result
				: _Json_runHelp(decoder.h(result.a), value);

		case 15:
			var errors = _List_Nil;
			for (var temp = decoder.g; temp.b; temp = temp.b) // WHILE_CONS
			{
				var result = _Json_runHelp(temp.a, value);
				if (elm$core$Result$isOk(result))
				{
					return result;
				}
				errors = _List_Cons(result.a, errors);
			}
			return elm$core$Result$Err(elm$json$Json$Decode$OneOf(elm$core$List$reverse(errors)));

		case 1:
			return elm$core$Result$Err(A2(elm$json$Json$Decode$Failure, decoder.a, _Json_wrap(value)));

		case 0:
			return elm$core$Result$Ok(decoder.a);
	}
}

function _Json_runArrayDecoder(decoder, value, toElmValue)
{
	var len = value.length;
	var array = new Array(len);
	for (var i = 0; i < len; i++)
	{
		var result = _Json_runHelp(decoder, value[i]);
		if (!elm$core$Result$isOk(result))
		{
			return elm$core$Result$Err(A2(elm$json$Json$Decode$Index, i, result.a));
		}
		array[i] = result.a;
	}
	return elm$core$Result$Ok(toElmValue(array));
}

function _Json_toElmArray(array)
{
	return A2(elm$core$Array$initialize, array.length, function(i) { return array[i]; });
}

function _Json_expecting(type, value)
{
	return elm$core$Result$Err(A2(elm$json$Json$Decode$Failure, 'Expecting ' + type, _Json_wrap(value)));
}


// EQUALITY

function _Json_equality(x, y)
{
	if (x === y)
	{
		return true;
	}

	if (x.$ !== y.$)
	{
		return false;
	}

	switch (x.$)
	{
		case 0:
		case 1:
			return x.a === y.a;

		case 3:
		case 2:
		case 4:
		case 6:
		case 5:
			return true;

		case 9:
			return x.c === y.c;

		case 7:
		case 8:
		case 12:
			return _Json_equality(x.b, y.b);

		case 10:
			return x.d === y.d && _Json_equality(x.b, y.b);

		case 11:
			return x.e === y.e && _Json_equality(x.b, y.b);

		case 13:
			return x.f === y.f && _Json_listEquality(x.g, y.g);

		case 14:
			return x.h === y.h && _Json_equality(x.b, y.b);

		case 15:
			return _Json_listEquality(x.g, y.g);
	}
}

function _Json_listEquality(aDecoders, bDecoders)
{
	var len = aDecoders.length;
	if (len !== bDecoders.length)
	{
		return false;
	}
	for (var i = 0; i < len; i++)
	{
		if (!_Json_equality(aDecoders[i], bDecoders[i]))
		{
			return false;
		}
	}
	return true;
}


// ENCODE

var _Json_encode = F2(function(indentLevel, value)
{
	return JSON.stringify(_Json_unwrap(value), null, indentLevel);
});

function _Json_wrap_UNUSED(value) { return { $: 0, a: value }; }
function _Json_unwrap_UNUSED(value) { return value.a; }

function _Json_wrap(value) { return value; }
function _Json_unwrap(value) { return value; }

function _Json_emptyArray() { return []; }
function _Json_emptyObject() { return {}; }

var _Json_addField = F3(function(key, value, object)
{
	object[key] = _Json_unwrap(value);
	return object;
});

function _Json_addEntry(func)
{
	return F2(function(entry, array)
	{
		array.push(_Json_unwrap(func(entry)));
		return array;
	});
}

var _Json_encodeNull = _Json_wrap(null);



function _Process_sleep(time)
{
	return _Scheduler_binding(function(callback) {
		var id = setTimeout(function() {
			callback(_Scheduler_succeed(_Utils_Tuple0));
		}, time);

		return function() { clearTimeout(id); };
	});
}




// PROGRAMS


var _Platform_worker = F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.cF,
		impl.dy,
		impl.de,
		function() { return function() {} }
	);
});



// INITIALIZE A PROGRAM


function _Platform_initialize(flagDecoder, args, init, update, subscriptions, stepperBuilder)
{
	var result = A2(_Json_run, flagDecoder, _Json_wrap(args ? args['flags'] : undefined));
	elm$core$Result$isOk(result) || _Debug_crash(2, result.a);
	var managers = {};
	result = init(result.a);
	var model = result.a;
	var stepper = stepperBuilder(sendToApp, model);
	var ports = _Platform_setupEffects(managers, sendToApp);

	function sendToApp(msg, viewMetadata)
	{
		result = A2(update, msg, model);
		stepper(model = result.a, viewMetadata);
		_Platform_dispatchEffects(managers, result.b, subscriptions(model));
	}

	_Platform_dispatchEffects(managers, result.b, subscriptions(model));

	return ports ? { ports: ports } : {};
}



// TRACK PRELOADS
//
// This is used by code in elm/browser and elm/http
// to register any HTTP requests that are triggered by init.
//


var _Platform_preload;


function _Platform_registerPreload(url)
{
	_Platform_preload.add(url);
}



// EFFECT MANAGERS


var _Platform_effectManagers = {};


function _Platform_setupEffects(managers, sendToApp)
{
	var ports;

	// setup all necessary effect managers
	for (var key in _Platform_effectManagers)
	{
		var manager = _Platform_effectManagers[key];

		if (manager.a)
		{
			ports = ports || {};
			ports[key] = manager.a(key, sendToApp);
		}

		managers[key] = _Platform_instantiateManager(manager, sendToApp);
	}

	return ports;
}


function _Platform_createManager(init, onEffects, onSelfMsg, cmdMap, subMap)
{
	return {
		b: init,
		c: onEffects,
		d: onSelfMsg,
		e: cmdMap,
		f: subMap
	};
}


function _Platform_instantiateManager(info, sendToApp)
{
	var router = {
		g: sendToApp,
		h: undefined
	};

	var onEffects = info.c;
	var onSelfMsg = info.d;
	var cmdMap = info.e;
	var subMap = info.f;

	function loop(state)
	{
		return A2(_Scheduler_andThen, loop, _Scheduler_receive(function(msg)
		{
			var value = msg.a;

			if (msg.$ === 0)
			{
				return A3(onSelfMsg, router, value, state);
			}

			return cmdMap && subMap
				? A4(onEffects, router, value.i, value.j, state)
				: A3(onEffects, router, cmdMap ? value.i : value.j, state);
		}));
	}

	return router.h = _Scheduler_rawSpawn(A2(_Scheduler_andThen, loop, info.b));
}



// ROUTING


var _Platform_sendToApp = F2(function(router, msg)
{
	return _Scheduler_binding(function(callback)
	{
		router.g(msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});


var _Platform_sendToSelf = F2(function(router, msg)
{
	return A2(_Scheduler_send, router.h, {
		$: 0,
		a: msg
	});
});



// BAGS


function _Platform_leaf(home)
{
	return function(value)
	{
		return {
			$: 1,
			k: home,
			l: value
		};
	};
}


function _Platform_batch(list)
{
	return {
		$: 2,
		m: list
	};
}


var _Platform_map = F2(function(tagger, bag)
{
	return {
		$: 3,
		n: tagger,
		o: bag
	}
});



// PIPE BAGS INTO EFFECT MANAGERS


function _Platform_dispatchEffects(managers, cmdBag, subBag)
{
	var effectsDict = {};
	_Platform_gatherEffects(true, cmdBag, effectsDict, null);
	_Platform_gatherEffects(false, subBag, effectsDict, null);

	for (var home in managers)
	{
		_Scheduler_rawSend(managers[home], {
			$: 'fx',
			a: effectsDict[home] || { i: _List_Nil, j: _List_Nil }
		});
	}
}


function _Platform_gatherEffects(isCmd, bag, effectsDict, taggers)
{
	switch (bag.$)
	{
		case 1:
			var home = bag.k;
			var effect = _Platform_toEffect(isCmd, home, taggers, bag.l);
			effectsDict[home] = _Platform_insert(isCmd, effect, effectsDict[home]);
			return;

		case 2:
			for (var list = bag.m; list.b; list = list.b) // WHILE_CONS
			{
				_Platform_gatherEffects(isCmd, list.a, effectsDict, taggers);
			}
			return;

		case 3:
			_Platform_gatherEffects(isCmd, bag.o, effectsDict, {
				p: bag.n,
				q: taggers
			});
			return;
	}
}


function _Platform_toEffect(isCmd, home, taggers, value)
{
	function applyTaggers(x)
	{
		for (var temp = taggers; temp; temp = temp.q)
		{
			x = temp.p(x);
		}
		return x;
	}

	var map = isCmd
		? _Platform_effectManagers[home].e
		: _Platform_effectManagers[home].f;

	return A2(map, applyTaggers, value)
}


function _Platform_insert(isCmd, newEffect, effects)
{
	effects = effects || { i: _List_Nil, j: _List_Nil };

	isCmd
		? (effects.i = _List_Cons(newEffect, effects.i))
		: (effects.j = _List_Cons(newEffect, effects.j));

	return effects;
}



// PORTS


function _Platform_checkPortName(name)
{
	if (_Platform_effectManagers[name])
	{
		_Debug_crash(3, name)
	}
}



// OUTGOING PORTS


function _Platform_outgoingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		e: _Platform_outgoingPortMap,
		r: converter,
		a: _Platform_setupOutgoingPort
	};
	return _Platform_leaf(name);
}


var _Platform_outgoingPortMap = F2(function(tagger, value) { return value; });


function _Platform_setupOutgoingPort(name)
{
	var subs = [];
	var converter = _Platform_effectManagers[name].r;

	// CREATE MANAGER

	var init = _Process_sleep(0);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, cmdList, state)
	{
		for ( ; cmdList.b; cmdList = cmdList.b) // WHILE_CONS
		{
			// grab a separate reference to subs in case unsubscribe is called
			var currentSubs = subs;
			var value = _Json_unwrap(converter(cmdList.a));
			for (var i = 0; i < currentSubs.length; i++)
			{
				currentSubs[i](value);
			}
		}
		return init;
	});

	// PUBLIC API

	function subscribe(callback)
	{
		subs.push(callback);
	}

	function unsubscribe(callback)
	{
		// copy subs into a new array in case unsubscribe is called within a
		// subscribed callback
		subs = subs.slice();
		var index = subs.indexOf(callback);
		if (index >= 0)
		{
			subs.splice(index, 1);
		}
	}

	return {
		subscribe: subscribe,
		unsubscribe: unsubscribe
	};
}



// INCOMING PORTS


function _Platform_incomingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		f: _Platform_incomingPortMap,
		r: converter,
		a: _Platform_setupIncomingPort
	};
	return _Platform_leaf(name);
}


var _Platform_incomingPortMap = F2(function(tagger, finalTagger)
{
	return function(value)
	{
		return tagger(finalTagger(value));
	};
});


function _Platform_setupIncomingPort(name, sendToApp)
{
	var subs = _List_Nil;
	var converter = _Platform_effectManagers[name].r;

	// CREATE MANAGER

	var init = _Scheduler_succeed(null);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, subList, state)
	{
		subs = subList;
		return init;
	});

	// PUBLIC API

	function send(incomingValue)
	{
		var result = A2(_Json_run, converter, _Json_wrap(incomingValue));

		elm$core$Result$isOk(result) || _Debug_crash(4, name, result.a);

		var value = result.a;
		for (var temp = subs; temp.b; temp = temp.b) // WHILE_CONS
		{
			sendToApp(temp.a(value));
		}
	}

	return { send: send };
}



// EXPORT ELM MODULES
//
// Have DEBUG and PROD versions so that we can (1) give nicer errors in
// debug mode and (2) not pay for the bits needed for that in prod mode.
//


function _Platform_export(exports)
{
	scope['Elm']
		? _Platform_mergeExportsProd(scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsProd(obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6)
				: _Platform_mergeExportsProd(obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}


function _Platform_export_UNUSED(exports)
{
	scope['Elm']
		? _Platform_mergeExportsDebug('Elm', scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsDebug(moduleName, obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6, moduleName)
				: _Platform_mergeExportsDebug(moduleName + '.' + name, obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}




// HELPERS


var _VirtualDom_divertHrefToApp;

var _VirtualDom_doc = typeof document !== 'undefined' ? document : {};


function _VirtualDom_appendChild(parent, child)
{
	parent.appendChild(child);
}

var _VirtualDom_init = F4(function(virtualNode, flagDecoder, debugMetadata, args)
{
	// NOTE: this function needs _Platform_export available to work

	/**/
	var node = args['node'];
	//*/
	/**_UNUSED/
	var node = args && args['node'] ? args['node'] : _Debug_crash(0);
	//*/

	node.parentNode.replaceChild(
		_VirtualDom_render(virtualNode, function() {}),
		node
	);

	return {};
});



// TEXT


function _VirtualDom_text(string)
{
	return {
		$: 0,
		a: string
	};
}



// NODE


var _VirtualDom_nodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 1,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_node = _VirtualDom_nodeNS(undefined);



// KEYED NODE


var _VirtualDom_keyedNodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 2,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_keyedNode = _VirtualDom_keyedNodeNS(undefined);



// CUSTOM


function _VirtualDom_custom(factList, model, render, diff)
{
	return {
		$: 3,
		d: _VirtualDom_organizeFacts(factList),
		g: model,
		h: render,
		i: diff
	};
}



// MAP


var _VirtualDom_map = F2(function(tagger, node)
{
	return {
		$: 4,
		j: tagger,
		k: node,
		b: 1 + (node.b || 0)
	};
});



// LAZY


function _VirtualDom_thunk(refs, thunk)
{
	return {
		$: 5,
		l: refs,
		m: thunk,
		k: undefined
	};
}

var _VirtualDom_lazy = F2(function(func, a)
{
	return _VirtualDom_thunk([func, a], function() {
		return func(a);
	});
});

var _VirtualDom_lazy2 = F3(function(func, a, b)
{
	return _VirtualDom_thunk([func, a, b], function() {
		return A2(func, a, b);
	});
});

var _VirtualDom_lazy3 = F4(function(func, a, b, c)
{
	return _VirtualDom_thunk([func, a, b, c], function() {
		return A3(func, a, b, c);
	});
});

var _VirtualDom_lazy4 = F5(function(func, a, b, c, d)
{
	return _VirtualDom_thunk([func, a, b, c, d], function() {
		return A4(func, a, b, c, d);
	});
});

var _VirtualDom_lazy5 = F6(function(func, a, b, c, d, e)
{
	return _VirtualDom_thunk([func, a, b, c, d, e], function() {
		return A5(func, a, b, c, d, e);
	});
});

var _VirtualDom_lazy6 = F7(function(func, a, b, c, d, e, f)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f], function() {
		return A6(func, a, b, c, d, e, f);
	});
});

var _VirtualDom_lazy7 = F8(function(func, a, b, c, d, e, f, g)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g], function() {
		return A7(func, a, b, c, d, e, f, g);
	});
});

var _VirtualDom_lazy8 = F9(function(func, a, b, c, d, e, f, g, h)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g, h], function() {
		return A8(func, a, b, c, d, e, f, g, h);
	});
});



// FACTS


var _VirtualDom_on = F2(function(key, handler)
{
	return {
		$: 'a0',
		n: key,
		o: handler
	};
});
var _VirtualDom_style = F2(function(key, value)
{
	return {
		$: 'a1',
		n: key,
		o: value
	};
});
var _VirtualDom_property = F2(function(key, value)
{
	return {
		$: 'a2',
		n: key,
		o: value
	};
});
var _VirtualDom_attribute = F2(function(key, value)
{
	return {
		$: 'a3',
		n: key,
		o: value
	};
});
var _VirtualDom_attributeNS = F3(function(namespace, key, value)
{
	return {
		$: 'a4',
		n: key,
		o: { f: namespace, o: value }
	};
});



// XSS ATTACK VECTOR CHECKS


function _VirtualDom_noScript(tag)
{
	return tag == 'script' ? 'p' : tag;
}

function _VirtualDom_noOnOrFormAction(key)
{
	return /^(on|formAction$)/i.test(key) ? 'data-' + key : key;
}

function _VirtualDom_noInnerHtmlOrFormAction(key)
{
	return key == 'innerHTML' || key == 'formAction' ? 'data-' + key : key;
}

function _VirtualDom_noJavaScriptUri(value)
{
	return /^\s*javascript:/i.test(value) ? '' : value;
}

function _VirtualDom_noJavaScriptUri_UNUSED(value)
{
	return /^\s*javascript:/i.test(value)
		? 'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'
		: value;
}

function _VirtualDom_noJavaScriptOrHtmlUri(value)
{
	return /^\s*(javascript:|data:text\/html)/i.test(value) ? '' : value;
}

function _VirtualDom_noJavaScriptOrHtmlUri_UNUSED(value)
{
	return /^\s*(javascript:|data:text\/html)/i.test(value)
		? 'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'
		: value;
}



// MAP FACTS


var _VirtualDom_mapAttribute = F2(function(func, attr)
{
	return (attr.$ === 'a0')
		? A2(_VirtualDom_on, attr.n, _VirtualDom_mapHandler(func, attr.o))
		: attr;
});

function _VirtualDom_mapHandler(func, handler)
{
	var tag = elm$virtual_dom$VirtualDom$toHandlerInt(handler);

	// 0 = Normal
	// 1 = MayStopPropagation
	// 2 = MayPreventDefault
	// 3 = Custom

	return {
		$: handler.$,
		a:
			!tag
				? A2(elm$json$Json$Decode$map, func, handler.a)
				:
			A3(elm$json$Json$Decode$map2,
				tag < 3
					? _VirtualDom_mapEventTuple
					: _VirtualDom_mapEventRecord,
				elm$json$Json$Decode$succeed(func),
				handler.a
			)
	};
}

var _VirtualDom_mapEventTuple = F2(function(func, tuple)
{
	return _Utils_Tuple2(func(tuple.a), tuple.b);
});

var _VirtualDom_mapEventRecord = F2(function(func, record)
{
	return {
		H: func(record.H),
		a4: record.a4,
		a1: record.a1
	}
});



// ORGANIZE FACTS


function _VirtualDom_organizeFacts(factList)
{
	for (var facts = {}; factList.b; factList = factList.b) // WHILE_CONS
	{
		var entry = factList.a;

		var tag = entry.$;
		var key = entry.n;
		var value = entry.o;

		if (tag === 'a2')
		{
			(key === 'className')
				? _VirtualDom_addClass(facts, key, _Json_unwrap(value))
				: facts[key] = _Json_unwrap(value);

			continue;
		}

		var subFacts = facts[tag] || (facts[tag] = {});
		(tag === 'a3' && key === 'class')
			? _VirtualDom_addClass(subFacts, key, value)
			: subFacts[key] = value;
	}

	return facts;
}

function _VirtualDom_addClass(object, key, newClass)
{
	var classes = object[key];
	object[key] = classes ? classes + ' ' + newClass : newClass;
}



// RENDER


function _VirtualDom_render(vNode, eventNode)
{
	var tag = vNode.$;

	if (tag === 5)
	{
		return _VirtualDom_render(vNode.k || (vNode.k = vNode.m()), eventNode);
	}

	if (tag === 0)
	{
		return _VirtualDom_doc.createTextNode(vNode.a);
	}

	if (tag === 4)
	{
		var subNode = vNode.k;
		var tagger = vNode.j;

		while (subNode.$ === 4)
		{
			typeof tagger !== 'object'
				? tagger = [tagger, subNode.j]
				: tagger.push(subNode.j);

			subNode = subNode.k;
		}

		var subEventRoot = { j: tagger, p: eventNode };
		var domNode = _VirtualDom_render(subNode, subEventRoot);
		domNode.elm_event_node_ref = subEventRoot;
		return domNode;
	}

	if (tag === 3)
	{
		var domNode = vNode.h(vNode.g);
		_VirtualDom_applyFacts(domNode, eventNode, vNode.d);
		return domNode;
	}

	// at this point `tag` must be 1 or 2

	var domNode = vNode.f
		? _VirtualDom_doc.createElementNS(vNode.f, vNode.c)
		: _VirtualDom_doc.createElement(vNode.c);

	if (_VirtualDom_divertHrefToApp && vNode.c == 'a')
	{
		domNode.addEventListener('click', _VirtualDom_divertHrefToApp(domNode));
	}

	_VirtualDom_applyFacts(domNode, eventNode, vNode.d);

	for (var kids = vNode.e, i = 0; i < kids.length; i++)
	{
		_VirtualDom_appendChild(domNode, _VirtualDom_render(tag === 1 ? kids[i] : kids[i].b, eventNode));
	}

	return domNode;
}



// APPLY FACTS


function _VirtualDom_applyFacts(domNode, eventNode, facts)
{
	for (var key in facts)
	{
		var value = facts[key];

		key === 'a1'
			? _VirtualDom_applyStyles(domNode, value)
			:
		key === 'a0'
			? _VirtualDom_applyEvents(domNode, eventNode, value)
			:
		key === 'a3'
			? _VirtualDom_applyAttrs(domNode, value)
			:
		key === 'a4'
			? _VirtualDom_applyAttrsNS(domNode, value)
			:
		(key !== 'value' || domNode[key] !== value) && (domNode[key] = value);
	}
}



// APPLY STYLES


function _VirtualDom_applyStyles(domNode, styles)
{
	var domNodeStyle = domNode.style;

	for (var key in styles)
	{
		domNodeStyle[key] = styles[key];
	}
}



// APPLY ATTRS


function _VirtualDom_applyAttrs(domNode, attrs)
{
	for (var key in attrs)
	{
		var value = attrs[key];
		value
			? domNode.setAttribute(key, value)
			: domNode.removeAttribute(key);
	}
}



// APPLY NAMESPACED ATTRS


function _VirtualDom_applyAttrsNS(domNode, nsAttrs)
{
	for (var key in nsAttrs)
	{
		var pair = nsAttrs[key];
		var namespace = pair.f;
		var value = pair.o;

		value
			? domNode.setAttributeNS(namespace, key, value)
			: domNode.removeAttributeNS(namespace, key);
	}
}



// APPLY EVENTS


function _VirtualDom_applyEvents(domNode, eventNode, events)
{
	var allCallbacks = domNode.elmFs || (domNode.elmFs = {});

	for (var key in events)
	{
		var newHandler = events[key];
		var oldCallback = allCallbacks[key];

		if (!newHandler)
		{
			domNode.removeEventListener(key, oldCallback);
			allCallbacks[key] = undefined;
			continue;
		}

		if (oldCallback)
		{
			var oldHandler = oldCallback.q;
			if (oldHandler.$ === newHandler.$)
			{
				oldCallback.q = newHandler;
				continue;
			}
			domNode.removeEventListener(key, oldCallback);
		}

		oldCallback = _VirtualDom_makeCallback(eventNode, newHandler);
		domNode.addEventListener(key, oldCallback,
			_VirtualDom_passiveSupported
			&& { passive: elm$virtual_dom$VirtualDom$toHandlerInt(newHandler) < 2 }
		);
		allCallbacks[key] = oldCallback;
	}
}



// PASSIVE EVENTS


var _VirtualDom_passiveSupported;

try
{
	window.addEventListener('t', null, Object.defineProperty({}, 'passive', {
		get: function() { _VirtualDom_passiveSupported = true; }
	}));
}
catch(e) {}



// EVENT HANDLERS


function _VirtualDom_makeCallback(eventNode, initialHandler)
{
	function callback(event)
	{
		var handler = callback.q;
		var result = _Json_runHelp(handler.a, event);

		if (!elm$core$Result$isOk(result))
		{
			return;
		}

		var tag = elm$virtual_dom$VirtualDom$toHandlerInt(handler);

		// 0 = Normal
		// 1 = MayStopPropagation
		// 2 = MayPreventDefault
		// 3 = Custom

		var value = result.a;
		var message = !tag ? value : tag < 3 ? value.a : value.H;
		var stopPropagation = tag == 1 ? value.b : tag == 3 && value.a4;
		var currentEventNode = (
			stopPropagation && event.stopPropagation(),
			(tag == 2 ? value.b : tag == 3 && value.a1) && event.preventDefault(),
			eventNode
		);
		var tagger;
		var i;
		while (tagger = currentEventNode.j)
		{
			if (typeof tagger == 'function')
			{
				message = tagger(message);
			}
			else
			{
				for (var i = tagger.length; i--; )
				{
					message = tagger[i](message);
				}
			}
			currentEventNode = currentEventNode.p;
		}
		currentEventNode(message, stopPropagation); // stopPropagation implies isSync
	}

	callback.q = initialHandler;

	return callback;
}

function _VirtualDom_equalEvents(x, y)
{
	return x.$ == y.$ && _Json_equality(x.a, y.a);
}



// DIFF


// TODO: Should we do patches like in iOS?
//
// type Patch
//   = At Int Patch
//   | Batch (List Patch)
//   | Change ...
//
// How could it not be better?
//
function _VirtualDom_diff(x, y)
{
	var patches = [];
	_VirtualDom_diffHelp(x, y, patches, 0);
	return patches;
}


function _VirtualDom_pushPatch(patches, type, index, data)
{
	var patch = {
		$: type,
		r: index,
		s: data,
		t: undefined,
		u: undefined
	};
	patches.push(patch);
	return patch;
}


function _VirtualDom_diffHelp(x, y, patches, index)
{
	if (x === y)
	{
		return;
	}

	var xType = x.$;
	var yType = y.$;

	// Bail if you run into different types of nodes. Implies that the
	// structure has changed significantly and it's not worth a diff.
	if (xType !== yType)
	{
		if (xType === 1 && yType === 2)
		{
			y = _VirtualDom_dekey(y);
			yType = 1;
		}
		else
		{
			_VirtualDom_pushPatch(patches, 0, index, y);
			return;
		}
	}

	// Now we know that both nodes are the same $.
	switch (yType)
	{
		case 5:
			var xRefs = x.l;
			var yRefs = y.l;
			var i = xRefs.length;
			var same = i === yRefs.length;
			while (same && i--)
			{
				same = xRefs[i] === yRefs[i];
			}
			if (same)
			{
				y.k = x.k;
				return;
			}
			y.k = y.m();
			var subPatches = [];
			_VirtualDom_diffHelp(x.k, y.k, subPatches, 0);
			subPatches.length > 0 && _VirtualDom_pushPatch(patches, 1, index, subPatches);
			return;

		case 4:
			// gather nested taggers
			var xTaggers = x.j;
			var yTaggers = y.j;
			var nesting = false;

			var xSubNode = x.k;
			while (xSubNode.$ === 4)
			{
				nesting = true;

				typeof xTaggers !== 'object'
					? xTaggers = [xTaggers, xSubNode.j]
					: xTaggers.push(xSubNode.j);

				xSubNode = xSubNode.k;
			}

			var ySubNode = y.k;
			while (ySubNode.$ === 4)
			{
				nesting = true;

				typeof yTaggers !== 'object'
					? yTaggers = [yTaggers, ySubNode.j]
					: yTaggers.push(ySubNode.j);

				ySubNode = ySubNode.k;
			}

			// Just bail if different numbers of taggers. This implies the
			// structure of the virtual DOM has changed.
			if (nesting && xTaggers.length !== yTaggers.length)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			// check if taggers are "the same"
			if (nesting ? !_VirtualDom_pairwiseRefEqual(xTaggers, yTaggers) : xTaggers !== yTaggers)
			{
				_VirtualDom_pushPatch(patches, 2, index, yTaggers);
			}

			// diff everything below the taggers
			_VirtualDom_diffHelp(xSubNode, ySubNode, patches, index + 1);
			return;

		case 0:
			if (x.a !== y.a)
			{
				_VirtualDom_pushPatch(patches, 3, index, y.a);
			}
			return;

		case 1:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKids);
			return;

		case 2:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKeyedKids);
			return;

		case 3:
			if (x.h !== y.h)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
			factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

			var patch = y.i(x.g, y.g);
			patch && _VirtualDom_pushPatch(patches, 5, index, patch);

			return;
	}
}

// assumes the incoming arrays are the same length
function _VirtualDom_pairwiseRefEqual(as, bs)
{
	for (var i = 0; i < as.length; i++)
	{
		if (as[i] !== bs[i])
		{
			return false;
		}
	}

	return true;
}

function _VirtualDom_diffNodes(x, y, patches, index, diffKids)
{
	// Bail if obvious indicators have changed. Implies more serious
	// structural changes such that it's not worth it to diff.
	if (x.c !== y.c || x.f !== y.f)
	{
		_VirtualDom_pushPatch(patches, 0, index, y);
		return;
	}

	var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
	factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

	diffKids(x, y, patches, index);
}



// DIFF FACTS


// TODO Instead of creating a new diff object, it's possible to just test if
// there *is* a diff. During the actual patch, do the diff again and make the
// modifications directly. This way, there's no new allocations. Worth it?
function _VirtualDom_diffFacts(x, y, category)
{
	var diff;

	// look for changes and removals
	for (var xKey in x)
	{
		if (xKey === 'a1' || xKey === 'a0' || xKey === 'a3' || xKey === 'a4')
		{
			var subDiff = _VirtualDom_diffFacts(x[xKey], y[xKey] || {}, xKey);
			if (subDiff)
			{
				diff = diff || {};
				diff[xKey] = subDiff;
			}
			continue;
		}

		// remove if not in the new facts
		if (!(xKey in y))
		{
			diff = diff || {};
			diff[xKey] =
				!category
					? (typeof x[xKey] === 'string' ? '' : null)
					:
				(category === 'a1')
					? ''
					:
				(category === 'a0' || category === 'a3')
					? undefined
					:
				{ f: x[xKey].f, o: undefined };

			continue;
		}

		var xValue = x[xKey];
		var yValue = y[xKey];

		// reference equal, so don't worry about it
		if (xValue === yValue && xKey !== 'value'
			|| category === 'a0' && _VirtualDom_equalEvents(xValue, yValue))
		{
			continue;
		}

		diff = diff || {};
		diff[xKey] = yValue;
	}

	// add new stuff
	for (var yKey in y)
	{
		if (!(yKey in x))
		{
			diff = diff || {};
			diff[yKey] = y[yKey];
		}
	}

	return diff;
}



// DIFF KIDS


function _VirtualDom_diffKids(xParent, yParent, patches, index)
{
	var xKids = xParent.e;
	var yKids = yParent.e;

	var xLen = xKids.length;
	var yLen = yKids.length;

	// FIGURE OUT IF THERE ARE INSERTS OR REMOVALS

	if (xLen > yLen)
	{
		_VirtualDom_pushPatch(patches, 6, index, {
			v: yLen,
			i: xLen - yLen
		});
	}
	else if (xLen < yLen)
	{
		_VirtualDom_pushPatch(patches, 7, index, {
			v: xLen,
			e: yKids
		});
	}

	// PAIRWISE DIFF EVERYTHING ELSE

	for (var minLen = xLen < yLen ? xLen : yLen, i = 0; i < minLen; i++)
	{
		var xKid = xKids[i];
		_VirtualDom_diffHelp(xKid, yKids[i], patches, ++index);
		index += xKid.b || 0;
	}
}



// KEYED DIFF


function _VirtualDom_diffKeyedKids(xParent, yParent, patches, rootIndex)
{
	var localPatches = [];

	var changes = {}; // Dict String Entry
	var inserts = []; // Array { index : Int, entry : Entry }
	// type Entry = { tag : String, vnode : VNode, index : Int, data : _ }

	var xKids = xParent.e;
	var yKids = yParent.e;
	var xLen = xKids.length;
	var yLen = yKids.length;
	var xIndex = 0;
	var yIndex = 0;

	var index = rootIndex;

	while (xIndex < xLen && yIndex < yLen)
	{
		var x = xKids[xIndex];
		var y = yKids[yIndex];

		var xKey = x.a;
		var yKey = y.a;
		var xNode = x.b;
		var yNode = y.b;

		// check if keys match

		if (xKey === yKey)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNode, localPatches, index);
			index += xNode.b || 0;

			xIndex++;
			yIndex++;
			continue;
		}

		// look ahead 1 to detect insertions and removals.

		var xNext = xKids[xIndex + 1];
		var yNext = yKids[yIndex + 1];

		if (xNext)
		{
			var xNextKey = xNext.a;
			var xNextNode = xNext.b;
			var oldMatch = yKey === xNextKey;
		}

		if (yNext)
		{
			var yNextKey = yNext.a;
			var yNextNode = yNext.b;
			var newMatch = xKey === yNextKey;
		}


		// swap x and y
		if (newMatch && oldMatch)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			_VirtualDom_insertNode(changes, localPatches, xKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNextNode, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		// insert y
		if (newMatch)
		{
			index++;
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			index += xNode.b || 0;

			xIndex += 1;
			yIndex += 2;
			continue;
		}

		// remove x
		if (oldMatch)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 1;
			continue;
		}

		// remove x, insert y
		if (xNext && xNextKey === yNextKey)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNextNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		break;
	}

	// eat up any remaining nodes with removeNode and insertNode

	while (xIndex < xLen)
	{
		index++;
		var x = xKids[xIndex];
		var xNode = x.b;
		_VirtualDom_removeNode(changes, localPatches, x.a, xNode, index);
		index += xNode.b || 0;
		xIndex++;
	}

	while (yIndex < yLen)
	{
		var endInserts = endInserts || [];
		var y = yKids[yIndex];
		_VirtualDom_insertNode(changes, localPatches, y.a, y.b, undefined, endInserts);
		yIndex++;
	}

	if (localPatches.length > 0 || inserts.length > 0 || endInserts)
	{
		_VirtualDom_pushPatch(patches, 8, rootIndex, {
			w: localPatches,
			x: inserts,
			y: endInserts
		});
	}
}



// CHANGES FROM KEYED DIFF


var _VirtualDom_POSTFIX = '_elmW6BL';


function _VirtualDom_insertNode(changes, localPatches, key, vnode, yIndex, inserts)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		entry = {
			c: 0,
			z: vnode,
			r: yIndex,
			s: undefined
		};

		inserts.push({ r: yIndex, A: entry });
		changes[key] = entry;

		return;
	}

	// this key was removed earlier, a match!
	if (entry.c === 1)
	{
		inserts.push({ r: yIndex, A: entry });

		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(entry.z, vnode, subPatches, entry.r);
		entry.r = yIndex;
		entry.s.s = {
			w: subPatches,
			A: entry
		};

		return;
	}

	// this key has already been inserted or moved, a duplicate!
	_VirtualDom_insertNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, yIndex, inserts);
}


function _VirtualDom_removeNode(changes, localPatches, key, vnode, index)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		var patch = _VirtualDom_pushPatch(localPatches, 9, index, undefined);

		changes[key] = {
			c: 1,
			z: vnode,
			r: index,
			s: patch
		};

		return;
	}

	// this key was inserted earlier, a match!
	if (entry.c === 0)
	{
		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(vnode, entry.z, subPatches, index);

		_VirtualDom_pushPatch(localPatches, 9, index, {
			w: subPatches,
			A: entry
		});

		return;
	}

	// this key has already been removed or moved, a duplicate!
	_VirtualDom_removeNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, index);
}



// ADD DOM NODES
//
// Each DOM node has an "index" assigned in order of traversal. It is important
// to minimize our crawl over the actual DOM, so these indexes (along with the
// descendantsCount of virtual nodes) let us skip touching entire subtrees of
// the DOM if we know there are no patches there.


function _VirtualDom_addDomNodes(domNode, vNode, patches, eventNode)
{
	_VirtualDom_addDomNodesHelp(domNode, vNode, patches, 0, 0, vNode.b, eventNode);
}


// assumes `patches` is non-empty and indexes increase monotonically.
function _VirtualDom_addDomNodesHelp(domNode, vNode, patches, i, low, high, eventNode)
{
	var patch = patches[i];
	var index = patch.r;

	while (index === low)
	{
		var patchType = patch.$;

		if (patchType === 1)
		{
			_VirtualDom_addDomNodes(domNode, vNode.k, patch.s, eventNode);
		}
		else if (patchType === 8)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var subPatches = patch.s.w;
			if (subPatches.length > 0)
			{
				_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
			}
		}
		else if (patchType === 9)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var data = patch.s;
			if (data)
			{
				data.A.s = domNode;
				var subPatches = data.w;
				if (subPatches.length > 0)
				{
					_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
				}
			}
		}
		else
		{
			patch.t = domNode;
			patch.u = eventNode;
		}

		i++;

		if (!(patch = patches[i]) || (index = patch.r) > high)
		{
			return i;
		}
	}

	var tag = vNode.$;

	if (tag === 4)
	{
		var subNode = vNode.k;

		while (subNode.$ === 4)
		{
			subNode = subNode.k;
		}

		return _VirtualDom_addDomNodesHelp(domNode, subNode, patches, i, low + 1, high, domNode.elm_event_node_ref);
	}

	// tag must be 1 or 2 at this point

	var vKids = vNode.e;
	var childNodes = domNode.childNodes;
	for (var j = 0; j < vKids.length; j++)
	{
		low++;
		var vKid = tag === 1 ? vKids[j] : vKids[j].b;
		var nextLow = low + (vKid.b || 0);
		if (low <= index && index <= nextLow)
		{
			i = _VirtualDom_addDomNodesHelp(childNodes[j], vKid, patches, i, low, nextLow, eventNode);
			if (!(patch = patches[i]) || (index = patch.r) > high)
			{
				return i;
			}
		}
		low = nextLow;
	}
	return i;
}



// APPLY PATCHES


function _VirtualDom_applyPatches(rootDomNode, oldVirtualNode, patches, eventNode)
{
	if (patches.length === 0)
	{
		return rootDomNode;
	}

	_VirtualDom_addDomNodes(rootDomNode, oldVirtualNode, patches, eventNode);
	return _VirtualDom_applyPatchesHelp(rootDomNode, patches);
}

function _VirtualDom_applyPatchesHelp(rootDomNode, patches)
{
	for (var i = 0; i < patches.length; i++)
	{
		var patch = patches[i];
		var localDomNode = patch.t
		var newNode = _VirtualDom_applyPatch(localDomNode, patch);
		if (localDomNode === rootDomNode)
		{
			rootDomNode = newNode;
		}
	}
	return rootDomNode;
}

function _VirtualDom_applyPatch(domNode, patch)
{
	switch (patch.$)
	{
		case 0:
			return _VirtualDom_applyPatchRedraw(domNode, patch.s, patch.u);

		case 4:
			_VirtualDom_applyFacts(domNode, patch.u, patch.s);
			return domNode;

		case 3:
			domNode.replaceData(0, domNode.length, patch.s);
			return domNode;

		case 1:
			return _VirtualDom_applyPatchesHelp(domNode, patch.s);

		case 2:
			if (domNode.elm_event_node_ref)
			{
				domNode.elm_event_node_ref.j = patch.s;
			}
			else
			{
				domNode.elm_event_node_ref = { j: patch.s, p: patch.u };
			}
			return domNode;

		case 6:
			var data = patch.s;
			for (var i = 0; i < data.i; i++)
			{
				domNode.removeChild(domNode.childNodes[data.v]);
			}
			return domNode;

		case 7:
			var data = patch.s;
			var kids = data.e;
			var i = data.v;
			var theEnd = domNode.childNodes[i];
			for (; i < kids.length; i++)
			{
				domNode.insertBefore(_VirtualDom_render(kids[i], patch.u), theEnd);
			}
			return domNode;

		case 9:
			var data = patch.s;
			if (!data)
			{
				domNode.parentNode.removeChild(domNode);
				return domNode;
			}
			var entry = data.A;
			if (typeof entry.r !== 'undefined')
			{
				domNode.parentNode.removeChild(domNode);
			}
			entry.s = _VirtualDom_applyPatchesHelp(domNode, data.w);
			return domNode;

		case 8:
			return _VirtualDom_applyPatchReorder(domNode, patch);

		case 5:
			return patch.s(domNode);

		default:
			_Debug_crash(10); // 'Ran into an unknown patch!'
	}
}


function _VirtualDom_applyPatchRedraw(domNode, vNode, eventNode)
{
	var parentNode = domNode.parentNode;
	var newNode = _VirtualDom_render(vNode, eventNode);

	if (!newNode.elm_event_node_ref)
	{
		newNode.elm_event_node_ref = domNode.elm_event_node_ref;
	}

	if (parentNode && newNode !== domNode)
	{
		parentNode.replaceChild(newNode, domNode);
	}
	return newNode;
}


function _VirtualDom_applyPatchReorder(domNode, patch)
{
	var data = patch.s;

	// remove end inserts
	var frag = _VirtualDom_applyPatchReorderEndInsertsHelp(data.y, patch);

	// removals
	domNode = _VirtualDom_applyPatchesHelp(domNode, data.w);

	// inserts
	var inserts = data.x;
	for (var i = 0; i < inserts.length; i++)
	{
		var insert = inserts[i];
		var entry = insert.A;
		var node = entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u);
		domNode.insertBefore(node, domNode.childNodes[insert.r]);
	}

	// add end inserts
	if (frag)
	{
		_VirtualDom_appendChild(domNode, frag);
	}

	return domNode;
}


function _VirtualDom_applyPatchReorderEndInsertsHelp(endInserts, patch)
{
	if (!endInserts)
	{
		return;
	}

	var frag = _VirtualDom_doc.createDocumentFragment();
	for (var i = 0; i < endInserts.length; i++)
	{
		var insert = endInserts[i];
		var entry = insert.A;
		_VirtualDom_appendChild(frag, entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u)
		);
	}
	return frag;
}


function _VirtualDom_virtualize(node)
{
	// TEXT NODES

	if (node.nodeType === 3)
	{
		return _VirtualDom_text(node.textContent);
	}


	// WEIRD NODES

	if (node.nodeType !== 1)
	{
		return _VirtualDom_text('');
	}


	// ELEMENT NODES

	var attrList = _List_Nil;
	var attrs = node.attributes;
	for (var i = attrs.length; i--; )
	{
		var attr = attrs[i];
		var name = attr.name;
		var value = attr.value;
		attrList = _List_Cons( A2(_VirtualDom_attribute, name, value), attrList );
	}

	var tag = node.tagName.toLowerCase();
	var kidList = _List_Nil;
	var kids = node.childNodes;

	for (var i = kids.length; i--; )
	{
		kidList = _List_Cons(_VirtualDom_virtualize(kids[i]), kidList);
	}
	return A3(_VirtualDom_node, tag, attrList, kidList);
}

function _VirtualDom_dekey(keyedNode)
{
	var keyedKids = keyedNode.e;
	var len = keyedKids.length;
	var kids = new Array(len);
	for (var i = 0; i < len; i++)
	{
		kids[i] = keyedKids[i].b;
	}

	return {
		$: 1,
		c: keyedNode.c,
		d: keyedNode.d,
		e: kids,
		f: keyedNode.f,
		b: keyedNode.b
	};
}


var _String_cons = F2(function(chr, str)
{
	return chr + str;
});

function _String_uncons(string)
{
	var word = string.charCodeAt(0);
	return word
		? elm$core$Maybe$Just(
			0xD800 <= word && word <= 0xDBFF
				? _Utils_Tuple2(_Utils_chr(string[0] + string[1]), string.slice(2))
				: _Utils_Tuple2(_Utils_chr(string[0]), string.slice(1))
		)
		: elm$core$Maybe$Nothing;
}

var _String_append = F2(function(a, b)
{
	return a + b;
});

function _String_length(str)
{
	return str.length;
}

var _String_map = F2(function(func, string)
{
	var len = string.length;
	var array = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = string.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			array[i] = func(_Utils_chr(string[i] + string[i+1]));
			i += 2;
			continue;
		}
		array[i] = func(_Utils_chr(string[i]));
		i++;
	}
	return array.join('');
});

var _String_filter = F2(function(isGood, str)
{
	var arr = [];
	var len = str.length;
	var i = 0;
	while (i < len)
	{
		var char = str[i];
		var word = str.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += str[i];
			i++;
		}

		if (isGood(_Utils_chr(char)))
		{
			arr.push(char);
		}
	}
	return arr.join('');
});

function _String_reverse(str)
{
	var len = str.length;
	var arr = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = str.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			arr[len - i] = str[i + 1];
			i++;
			arr[len - i] = str[i - 1];
			i++;
		}
		else
		{
			arr[len - i] = str[i];
			i++;
		}
	}
	return arr.join('');
}

var _String_foldl = F3(function(func, state, string)
{
	var len = string.length;
	var i = 0;
	while (i < len)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += string[i];
			i++;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_foldr = F3(function(func, state, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_split = F2(function(sep, str)
{
	return str.split(sep);
});

var _String_join = F2(function(sep, strs)
{
	return strs.join(sep);
});

var _String_slice = F3(function(start, end, str) {
	return str.slice(start, end);
});

function _String_trim(str)
{
	return str.trim();
}

function _String_trimLeft(str)
{
	return str.replace(/^\s+/, '');
}

function _String_trimRight(str)
{
	return str.replace(/\s+$/, '');
}

function _String_words(str)
{
	return _List_fromArray(str.trim().split(/\s+/g));
}

function _String_lines(str)
{
	return _List_fromArray(str.split(/\r\n|\r|\n/g));
}

function _String_toUpper(str)
{
	return str.toUpperCase();
}

function _String_toLower(str)
{
	return str.toLowerCase();
}

var _String_any = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (isGood(_Utils_chr(char)))
		{
			return true;
		}
	}
	return false;
});

var _String_all = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (!isGood(_Utils_chr(char)))
		{
			return false;
		}
	}
	return true;
});

var _String_contains = F2(function(sub, str)
{
	return str.indexOf(sub) > -1;
});

var _String_startsWith = F2(function(sub, str)
{
	return str.indexOf(sub) === 0;
});

var _String_endsWith = F2(function(sub, str)
{
	return str.length >= sub.length &&
		str.lastIndexOf(sub) === str.length - sub.length;
});

var _String_indexes = F2(function(sub, str)
{
	var subLen = sub.length;

	if (subLen < 1)
	{
		return _List_Nil;
	}

	var i = 0;
	var is = [];

	while ((i = str.indexOf(sub, i)) > -1)
	{
		is.push(i);
		i = i + subLen;
	}

	return _List_fromArray(is);
});


// TO STRING

function _String_fromNumber(number)
{
	return number + '';
}


// INT CONVERSIONS

function _String_toInt(str)
{
	var total = 0;
	var code0 = str.charCodeAt(0);
	var start = code0 == 0x2B /* + */ || code0 == 0x2D /* - */ ? 1 : 0;

	for (var i = start; i < str.length; ++i)
	{
		var code = str.charCodeAt(i);
		if (code < 0x30 || 0x39 < code)
		{
			return elm$core$Maybe$Nothing;
		}
		total = 10 * total + code - 0x30;
	}

	return i == start
		? elm$core$Maybe$Nothing
		: elm$core$Maybe$Just(code0 == 0x2D ? -total : total);
}


// FLOAT CONVERSIONS

function _String_toFloat(s)
{
	// check if it is a hex, octal, or binary number
	if (s.length === 0 || /[\sxbo]/.test(s))
	{
		return elm$core$Maybe$Nothing;
	}
	var n = +s;
	// faster isNaN check
	return n === n ? elm$core$Maybe$Just(n) : elm$core$Maybe$Nothing;
}

function _String_fromList(chars)
{
	return _List_toArray(chars).join('');
}





// ELEMENT


var _Debugger_element;

var _Browser_element = _Debugger_element || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.cF,
		impl.dy,
		impl.de,
		function(sendToApp, initialModel) {
			var view = impl.dA;
			/**/
			var domNode = args['node'];
			//*/
			/**_UNUSED/
			var domNode = args && args['node'] ? args['node'] : _Debug_crash(0);
			//*/
			var currNode = _VirtualDom_virtualize(domNode);

			return _Browser_makeAnimator(initialModel, function(model)
			{
				var nextNode = view(model);
				var patches = _VirtualDom_diff(currNode, nextNode);
				domNode = _VirtualDom_applyPatches(domNode, currNode, patches, sendToApp);
				currNode = nextNode;
			});
		}
	);
});



// DOCUMENT


var _Debugger_document;

var _Browser_document = _Debugger_document || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.cF,
		impl.dy,
		impl.de,
		function(sendToApp, initialModel) {
			var divertHrefToApp = impl.a2 && impl.a2(sendToApp)
			var view = impl.dA;
			var title = _VirtualDom_doc.title;
			var bodyNode = _VirtualDom_doc.body;
			var currNode = _VirtualDom_virtualize(bodyNode);
			return _Browser_makeAnimator(initialModel, function(model)
			{
				_VirtualDom_divertHrefToApp = divertHrefToApp;
				var doc = view(model);
				var nextNode = _VirtualDom_node('body')(_List_Nil)(doc.ba);
				var patches = _VirtualDom_diff(currNode, nextNode);
				bodyNode = _VirtualDom_applyPatches(bodyNode, currNode, patches, sendToApp);
				currNode = nextNode;
				_VirtualDom_divertHrefToApp = 0;
				(title !== doc.bT) && (_VirtualDom_doc.title = title = doc.bT);
			});
		}
	);
});



// ANIMATION


var _Browser_requestAnimationFrame =
	typeof requestAnimationFrame !== 'undefined'
		? requestAnimationFrame
		: function(callback) { setTimeout(callback, 1000 / 60); };


function _Browser_makeAnimator(model, draw)
{
	draw(model);

	var state = 0;

	function updateIfNeeded()
	{
		state = state === 1
			? 0
			: ( _Browser_requestAnimationFrame(updateIfNeeded), draw(model), 1 );
	}

	return function(nextModel, isSync)
	{
		model = nextModel;

		isSync
			? ( draw(model),
				state === 2 && (state = 1)
				)
			: ( state === 0 && _Browser_requestAnimationFrame(updateIfNeeded),
				state = 2
				);
	};
}



// APPLICATION


function _Browser_application(impl)
{
	var key = {};
	var onUrlChange = impl.cU;
	var onUrlRequest = impl.cV;
	return _Browser_document({
		a2: function(sendToApp)
		{
			function reportChange()
			{
				sendToApp(onUrlChange(_Browser_getUrl()));
			}

			key.a = reportChange;

			_Browser_window.addEventListener('popstate', reportChange);
			_Browser_window.navigator.userAgent.indexOf('Trident') < 0 || _Browser_window.addEventListener('hashchange', reportChange);

			return F2(function(domNode, event)
			{
				if (!event.ctrlKey && !event.metaKey && !event.shiftKey && event.button < 1 && !domNode.target)
				{
					event.preventDefault();
					var href = domNode.href;
					var curr = _Browser_getUrl();
					var next = elm$url$Url$fromString(href).a;
					sendToApp(onUrlRequest(
						(next
							&& curr.bH === next.bH
							&& curr.bq === next.bq
							&& curr.bD.a === next.bD.a
						)
							? elm$browser$Browser$Internal(next)
							: elm$browser$Browser$External(href)
					));
				}
			});
		},
		cF: function(flags)
		{
			return A3(impl.cF, flags, _Browser_getUrl(), key);
		},
		dA: impl.dA,
		dy: impl.dy,
		de: impl.de
	});
}

function _Browser_getUrl()
{
	return elm$url$Url$fromString(_VirtualDom_doc.location.href).a || _Debug_crash(1);
}

var _Browser_go = F2(function(key, n)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function() {
		n && history.go(n);
		key.a();
	}));
});

var _Browser_pushUrl = F2(function(key, url)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function() {
		history.pushState({}, '', url);
		key.a();
	}));
});

var _Browser_replaceUrl = F2(function(key, url)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function() {
		history.replaceState({}, '', url);
		key.a();
	}));
});



// GLOBAL EVENTS


var _Browser_fakeNode = { addEventListener: function() {}, removeEventListener: function() {} };
var _Browser_doc = typeof document !== 'undefined' ? document : _Browser_fakeNode;
var _Browser_window = typeof window !== 'undefined' ? window : _Browser_fakeNode;

var _Browser_on = F3(function(node, eventName, sendToSelf)
{
	return _Scheduler_spawn(_Scheduler_binding(function(callback)
	{
		function handler(event)	{ _Scheduler_rawSpawn(sendToSelf(event)); }
		node.addEventListener(eventName, handler, _VirtualDom_passiveSupported && { passive: true });
		return function() { node.removeEventListener(eventName, handler); };
	}));
});

var _Browser_decodeEvent = F2(function(decoder, event)
{
	var result = _Json_runHelp(decoder, event);
	return elm$core$Result$isOk(result) ? elm$core$Maybe$Just(result.a) : elm$core$Maybe$Nothing;
});



// PAGE VISIBILITY


function _Browser_visibilityInfo()
{
	return (typeof _VirtualDom_doc.hidden !== 'undefined')
		? { cy: 'hidden', ah: 'visibilitychange' }
		:
	(typeof _VirtualDom_doc.mozHidden !== 'undefined')
		? { cy: 'mozHidden', ah: 'mozvisibilitychange' }
		:
	(typeof _VirtualDom_doc.msHidden !== 'undefined')
		? { cy: 'msHidden', ah: 'msvisibilitychange' }
		:
	(typeof _VirtualDom_doc.webkitHidden !== 'undefined')
		? { cy: 'webkitHidden', ah: 'webkitvisibilitychange' }
		: { cy: 'hidden', ah: 'visibilitychange' };
}



// ANIMATION FRAMES


function _Browser_rAF()
{
	return _Scheduler_binding(function(callback)
	{
		var id = requestAnimationFrame(function() {
			callback(_Scheduler_succeed(Date.now()));
		});

		return function() {
			cancelAnimationFrame(id);
		};
	});
}


function _Browser_now()
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(Date.now()));
	});
}



// DOM STUFF


function _Browser_withNode(id, doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			var node = document.getElementById(id);
			callback(node
				? _Scheduler_succeed(doStuff(node))
				: _Scheduler_fail(elm$browser$Browser$Dom$NotFound(id))
			);
		});
	});
}


function _Browser_withWindow(doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(doStuff()));
		});
	});
}


// FOCUS and BLUR


var _Browser_call = F2(function(functionName, id)
{
	return _Browser_withNode(id, function(node) {
		node[functionName]();
		return _Utils_Tuple0;
	});
});



// WINDOW VIEWPORT


function _Browser_getViewport()
{
	var node = _Browser_doc.documentElement;
	return {
		bL: {
			D: node.scrollWidth,
			G: node.scrollHeight
		},
		dB: {
			ay: _Browser_window.pageXOffset,
			az: _Browser_window.pageYOffset,
			D: node.clientWidth,
			G: node.clientHeight
		}
	};
}


var _Browser_setViewport = F2(function(x, y)
{
	return _Browser_withWindow(function()
	{
		_Browser_window.scroll(x, y);
		return _Utils_Tuple0;
	});
});



// ELEMENT VIEWPORT


function _Browser_getViewportOf(id)
{
	return _Browser_withNode(id, function(node)
	{
		return {
			bL: {
				D: node.scrollWidth,
				G: node.scrollHeight
			},
			dB: {
				ay: node.scrollLeft,
				az: node.scrollTop,
				D: node.clientWidth,
				G: node.clientHeight
			}
		};
	});
}


var _Browser_setViewportOf = F3(function(id, x, y)
{
	return _Browser_withNode(id, function(node)
	{
		node.scrollLeft = x;
		node.scrollTop = y;
		return _Utils_Tuple0;
	});
});



// ELEMENT


function _Browser_getElement(id)
{
	return _Browser_withNode(id, function(node)
	{
		var rect = node.getBoundingClientRect();
		var x = _Browser_window.pageXOffset;
		var y = _Browser_window.pageYOffset;
		return {
			bL: {
				D: node.scrollWidth,
				G: node.scrollHeight
			},
			dB: {
				ay: x,
				az: y,
				D: node.clientWidth,
				G: node.clientHeight
			},
			cr: {
				ay: x + rect.left,
				az: y + rect.top,
				D: rect.width,
				G: rect.height
			}
		};
	});
}



// LOAD and RELOAD


function _Browser_reload(skipCache)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		_VirtualDom_doc.location.reload(skipCache);
	}));
}

function _Browser_load(url)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		try
		{
			_Browser_window.location = url;
		}
		catch(err)
		{
			// Only Firefox can throw a NS_ERROR_MALFORMED_URI exception here.
			// Other browsers reload the page, so let's be consistent about that.
			_VirtualDom_doc.location.reload(false);
		}
	}));
}



var _Bitwise_and = F2(function(a, b)
{
	return a & b;
});

var _Bitwise_or = F2(function(a, b)
{
	return a | b;
});

var _Bitwise_xor = F2(function(a, b)
{
	return a ^ b;
});

function _Bitwise_complement(a)
{
	return ~a;
};

var _Bitwise_shiftLeftBy = F2(function(offset, a)
{
	return a << offset;
});

var _Bitwise_shiftRightBy = F2(function(offset, a)
{
	return a >> offset;
});

var _Bitwise_shiftRightZfBy = F2(function(offset, a)
{
	return a >>> offset;
});
var author$project$Main$UrlChanged = function (a) {
	return {$: 3, a: a};
};
var author$project$Main$UrlRequest = function (a) {
	return {$: 4, a: a};
};
var author$project$Animation$Model$Animation = elm$core$Basics$identity;
var elm$core$Basics$False = 1;
var elm$core$Basics$identity = function (x) {
	return x;
};
var elm$core$Basics$EQ = 1;
var elm$core$Basics$LT = 0;
var elm$core$Elm$JsArray$foldr = _JsArray_foldr;
var elm$core$Array$foldr = F3(
	function (func, baseCase, _n0) {
		var tree = _n0.c;
		var tail = _n0.d;
		var helper = F2(
			function (node, acc) {
				if (!node.$) {
					var subTree = node.a;
					return A3(elm$core$Elm$JsArray$foldr, helper, acc, subTree);
				} else {
					var values = node.a;
					return A3(elm$core$Elm$JsArray$foldr, func, acc, values);
				}
			});
		return A3(
			elm$core$Elm$JsArray$foldr,
			helper,
			A3(elm$core$Elm$JsArray$foldr, func, baseCase, tail),
			tree);
	});
var elm$core$List$cons = _List_cons;
var elm$core$Array$toList = function (array) {
	return A3(elm$core$Array$foldr, elm$core$List$cons, _List_Nil, array);
};
var elm$core$Basics$GT = 2;
var elm$core$Dict$foldr = F3(
	function (func, acc, t) {
		foldr:
		while (true) {
			if (t.$ === -2) {
				return acc;
			} else {
				var key = t.b;
				var value = t.c;
				var left = t.d;
				var right = t.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3(elm$core$Dict$foldr, func, acc, right)),
					$temp$t = left;
				func = $temp$func;
				acc = $temp$acc;
				t = $temp$t;
				continue foldr;
			}
		}
	});
var elm$core$Dict$toList = function (dict) {
	return A3(
		elm$core$Dict$foldr,
		F3(
			function (key, value, list) {
				return A2(
					elm$core$List$cons,
					_Utils_Tuple2(key, value),
					list);
			}),
		_List_Nil,
		dict);
};
var elm$core$Dict$keys = function (dict) {
	return A3(
		elm$core$Dict$foldr,
		F3(
			function (key, value, keyList) {
				return A2(elm$core$List$cons, key, keyList);
			}),
		_List_Nil,
		dict);
};
var elm$core$Set$toList = function (_n0) {
	var dict = _n0;
	return elm$core$Dict$keys(dict);
};
var elm$time$Time$Posix = elm$core$Basics$identity;
var elm$time$Time$millisToPosix = elm$core$Basics$identity;
var author$project$Animation$initialState = function (current) {
	return {
		aZ: _List_Nil,
		aM: false,
		a3: _List_Nil,
		bP: current,
		bS: {
			bh: elm$time$Time$millisToPosix(0),
			cq: elm$time$Time$millisToPosix(0)
		}
	};
};
var author$project$Animation$Model$AtSpeed = function (a) {
	return {$: 2, a: a};
};
var author$project$Animation$speed = function (speedValue) {
	return author$project$Animation$Model$AtSpeed(speedValue);
};
var author$project$Animation$Model$Easing = function (a) {
	return {$: 1, a: a};
};
var author$project$Animation$Model$Spring = function (a) {
	return {$: 0, a: a};
};
var elm$core$Basics$eq = _Utils_equal;
var elm$core$Basics$pi = _Basics_pi;
var author$project$Animation$defaultInterpolationByProperty = function (prop) {
	var linear = function (duration) {
		return author$project$Animation$Model$Easing(
			{aV: duration, aW: elm$core$Basics$identity, bG: 1, bN: 0});
	};
	var defaultSpring = author$project$Animation$Model$Spring(
		{bi: 26, bO: 170});
	switch (prop.$) {
		case 0:
			return defaultSpring;
		case 1:
			return linear(
				elm$time$Time$millisToPosix(400));
		case 2:
			return defaultSpring;
		case 3:
			return defaultSpring;
		case 4:
			return defaultSpring;
		case 5:
			var name = prop.a;
			return (name === 'rotate3d') ? author$project$Animation$speed(
				{bB: elm$core$Basics$pi}) : defaultSpring;
		case 6:
			return defaultSpring;
		case 7:
			return author$project$Animation$speed(
				{bB: elm$core$Basics$pi});
		case 8:
			return defaultSpring;
		default:
			return defaultSpring;
	}
};
var author$project$Animation$Model$AngleProperty = F2(
	function (a, b) {
		return {$: 7, a: a, b: b};
	});
var author$project$Animation$Model$ColorProperty = F5(
	function (a, b, c, d, e) {
		return {$: 1, a: a, b: b, c: c, d: d, e: e};
	});
var author$project$Animation$Model$ExactProperty = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var author$project$Animation$Model$Path = function (a) {
	return {$: 9, a: a};
};
var author$project$Animation$Model$Points = function (a) {
	return {$: 8, a: a};
};
var author$project$Animation$Model$Property = F2(
	function (a, b) {
		return {$: 3, a: a, b: b};
	});
var author$project$Animation$Model$Property2 = F3(
	function (a, b, c) {
		return {$: 4, a: a, b: b, c: c};
	});
var author$project$Animation$Model$Property3 = F4(
	function (a, b, c, d) {
		return {$: 5, a: a, b: b, c: c, d: d};
	});
var author$project$Animation$Model$Property4 = F5(
	function (a, b, c, d, e) {
		return {$: 6, a: a, b: b, c: c, d: d, e: e};
	});
var author$project$Animation$Model$ShadowProperty = F3(
	function (a, b, c) {
		return {$: 2, a: a, b: b, c: c};
	});
var author$project$Animation$Model$AntiClockwiseArc = function (a) {
	return {$: 17, a: a};
};
var author$project$Animation$Model$ClockwiseArc = function (a) {
	return {$: 16, a: a};
};
var author$project$Animation$Model$Close = {$: 18};
var author$project$Animation$Model$Curve = function (a) {
	return {$: 8, a: a};
};
var author$project$Animation$Model$CurveTo = function (a) {
	return {$: 9, a: a};
};
var author$project$Animation$Model$Horizontal = function (a) {
	return {$: 4, a: a};
};
var author$project$Animation$Model$HorizontalTo = function (a) {
	return {$: 5, a: a};
};
var author$project$Animation$Model$Line = F2(
	function (a, b) {
		return {$: 2, a: a, b: b};
	});
var author$project$Animation$Model$LineTo = F2(
	function (a, b) {
		return {$: 3, a: a, b: b};
	});
var author$project$Animation$Model$Move = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var author$project$Animation$Model$MoveTo = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var author$project$Animation$Model$Quadratic = function (a) {
	return {$: 10, a: a};
};
var author$project$Animation$Model$QuadraticTo = function (a) {
	return {$: 11, a: a};
};
var author$project$Animation$Model$Smooth = function (a) {
	return {$: 14, a: a};
};
var author$project$Animation$Model$SmoothQuadratic = function (a) {
	return {$: 12, a: a};
};
var author$project$Animation$Model$SmoothQuadraticTo = function (a) {
	return {$: 13, a: a};
};
var author$project$Animation$Model$SmoothTo = function (a) {
	return {$: 15, a: a};
};
var author$project$Animation$Model$Vertical = function (a) {
	return {$: 6, a: a};
};
var author$project$Animation$Model$VerticalTo = function (a) {
	return {$: 7, a: a};
};
var elm$core$Basics$apL = F2(
	function (f, x) {
		return f(x);
	});
var elm$core$Basics$add = _Basics_add;
var elm$core$Basics$gt = _Utils_gt;
var elm$core$List$foldl = F3(
	function (func, acc, list) {
		foldl:
		while (true) {
			if (!list.b) {
				return acc;
			} else {
				var x = list.a;
				var xs = list.b;
				var $temp$func = func,
					$temp$acc = A2(func, x, acc),
					$temp$list = xs;
				func = $temp$func;
				acc = $temp$acc;
				list = $temp$list;
				continue foldl;
			}
		}
	});
var elm$core$List$reverse = function (list) {
	return A3(elm$core$List$foldl, elm$core$List$cons, _List_Nil, list);
};
var elm$core$List$foldrHelper = F4(
	function (fn, acc, ctr, ls) {
		if (!ls.b) {
			return acc;
		} else {
			var a = ls.a;
			var r1 = ls.b;
			if (!r1.b) {
				return A2(fn, a, acc);
			} else {
				var b = r1.a;
				var r2 = r1.b;
				if (!r2.b) {
					return A2(
						fn,
						a,
						A2(fn, b, acc));
				} else {
					var c = r2.a;
					var r3 = r2.b;
					if (!r3.b) {
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(fn, c, acc)));
					} else {
						var d = r3.a;
						var r4 = r3.b;
						var res = (ctr > 500) ? A3(
							elm$core$List$foldl,
							fn,
							acc,
							elm$core$List$reverse(r4)) : A4(elm$core$List$foldrHelper, fn, acc, ctr + 1, r4);
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(
									fn,
									c,
									A2(fn, d, res))));
					}
				}
			}
		}
	});
var elm$core$List$foldr = F3(
	function (fn, acc, ls) {
		return A4(elm$core$List$foldrHelper, fn, acc, 0, ls);
	});
var elm$core$List$map = F2(
	function (f, xs) {
		return A3(
			elm$core$List$foldr,
			F2(
				function (x, acc) {
					return A2(
						elm$core$List$cons,
						f(x),
						acc);
				}),
			_List_Nil,
			xs);
	});
var elm$core$Tuple$first = function (_n0) {
	var x = _n0.a;
	return x;
};
var elm$core$Tuple$second = function (_n0) {
	var y = _n0.b;
	return y;
};
var author$project$Animation$Model$mapPathMotion = F2(
	function (fn, cmd) {
		var mapCoords = function (coords) {
			return A2(
				elm$core$List$map,
				function (_n1) {
					var x = _n1.a;
					var y = _n1.b;
					return _Utils_Tuple2(
						fn(x),
						fn(y));
				},
				coords);
		};
		switch (cmd.$) {
			case 0:
				var m1 = cmd.a;
				var m2 = cmd.b;
				return A2(
					author$project$Animation$Model$Move,
					fn(m1),
					fn(m2));
			case 1:
				var m1 = cmd.a;
				var m2 = cmd.b;
				return A2(
					author$project$Animation$Model$MoveTo,
					fn(m1),
					fn(m2));
			case 2:
				var m1 = cmd.a;
				var m2 = cmd.b;
				return A2(
					author$project$Animation$Model$Line,
					fn(m1),
					fn(m2));
			case 3:
				var m1 = cmd.a;
				var m2 = cmd.b;
				return A2(
					author$project$Animation$Model$LineTo,
					fn(m1),
					fn(m2));
			case 4:
				var motion = cmd.a;
				return author$project$Animation$Model$Horizontal(
					fn(motion));
			case 5:
				var motion = cmd.a;
				return author$project$Animation$Model$HorizontalTo(
					fn(motion));
			case 6:
				var motion = cmd.a;
				return author$project$Animation$Model$Vertical(
					fn(motion));
			case 7:
				var motion = cmd.a;
				return author$project$Animation$Model$VerticalTo(
					fn(motion));
			case 8:
				var control1 = cmd.a.ak;
				var control2 = cmd.a.al;
				var point = cmd.a.w;
				return author$project$Animation$Model$Curve(
					{
						ak: _Utils_Tuple2(
							fn(control1.a),
							fn(control1.b)),
						al: _Utils_Tuple2(
							fn(control2.a),
							fn(control2.b)),
						w: _Utils_Tuple2(
							fn(point.a),
							fn(point.b))
					});
			case 9:
				var control1 = cmd.a.ak;
				var control2 = cmd.a.al;
				var point = cmd.a.w;
				return author$project$Animation$Model$CurveTo(
					{
						ak: _Utils_Tuple2(
							fn(control1.a),
							fn(control1.b)),
						al: _Utils_Tuple2(
							fn(control2.a),
							fn(control2.b)),
						w: _Utils_Tuple2(
							fn(point.a),
							fn(point.b))
					});
			case 10:
				var control = cmd.a.aj;
				var point = cmd.a.w;
				return author$project$Animation$Model$Quadratic(
					{
						aj: _Utils_Tuple2(
							fn(control.a),
							fn(control.b)),
						w: _Utils_Tuple2(
							fn(point.a),
							fn(point.b))
					});
			case 11:
				var control = cmd.a.aj;
				var point = cmd.a.w;
				return author$project$Animation$Model$QuadraticTo(
					{
						aj: _Utils_Tuple2(
							fn(control.a),
							fn(control.b)),
						w: _Utils_Tuple2(
							fn(point.a),
							fn(point.b))
					});
			case 12:
				var coords = cmd.a;
				return author$project$Animation$Model$SmoothQuadratic(
					mapCoords(coords));
			case 13:
				var coords = cmd.a;
				return author$project$Animation$Model$SmoothQuadraticTo(
					mapCoords(coords));
			case 14:
				var coords = cmd.a;
				return author$project$Animation$Model$Smooth(
					mapCoords(coords));
			case 15:
				var coords = cmd.a;
				return author$project$Animation$Model$SmoothTo(
					mapCoords(coords));
			case 16:
				var arc = cmd.a;
				return author$project$Animation$Model$ClockwiseArc(
					function () {
						var y = arc.az;
						var x = arc.ay;
						var startAngle = arc.as;
						var radius = arc.ar;
						var endAngle = arc.am;
						return _Utils_update(
							arc,
							{
								am: fn(endAngle),
								ar: fn(radius),
								as: fn(startAngle),
								ay: fn(x),
								az: fn(y)
							});
					}());
			case 17:
				var arc = cmd.a;
				return author$project$Animation$Model$AntiClockwiseArc(
					function () {
						var y = arc.az;
						var x = arc.ay;
						var startAngle = arc.as;
						var radius = arc.ar;
						var endAngle = arc.am;
						return _Utils_update(
							arc,
							{
								am: fn(endAngle),
								ar: fn(radius),
								as: fn(startAngle),
								ay: fn(x),
								az: fn(y)
							});
					}());
			default:
				return author$project$Animation$Model$Close;
		}
	});
var author$project$Animation$Model$mapToMotion = F2(
	function (fn, prop) {
		switch (prop.$) {
			case 0:
				var name = prop.a;
				var value = prop.b;
				return A2(author$project$Animation$Model$ExactProperty, name, value);
			case 1:
				var name = prop.a;
				var m1 = prop.b;
				var m2 = prop.c;
				var m3 = prop.d;
				var m4 = prop.e;
				return A5(
					author$project$Animation$Model$ColorProperty,
					name,
					fn(m1),
					fn(m2),
					fn(m3),
					fn(m4));
			case 2:
				var name = prop.a;
				var inset = prop.b;
				var shadow = prop.c;
				var size = shadow.x;
				var red = shadow.m;
				var offsetY = shadow.u;
				var offsetX = shadow.t;
				var green = shadow.l;
				var blur = shadow.s;
				var blue = shadow.j;
				var alpha = shadow.i;
				return A3(
					author$project$Animation$Model$ShadowProperty,
					name,
					inset,
					{
						i: fn(alpha),
						j: fn(blue),
						s: fn(blur),
						l: fn(green),
						t: fn(offsetX),
						u: fn(offsetY),
						m: fn(red),
						x: fn(size)
					});
			case 3:
				var name = prop.a;
				var m1 = prop.b;
				return A2(
					author$project$Animation$Model$Property,
					name,
					fn(m1));
			case 4:
				var name = prop.a;
				var m1 = prop.b;
				var m2 = prop.c;
				return A3(
					author$project$Animation$Model$Property2,
					name,
					fn(m1),
					fn(m2));
			case 5:
				var name = prop.a;
				var m1 = prop.b;
				var m2 = prop.c;
				var m3 = prop.d;
				return A4(
					author$project$Animation$Model$Property3,
					name,
					fn(m1),
					fn(m2),
					fn(m3));
			case 6:
				var name = prop.a;
				var m1 = prop.b;
				var m2 = prop.c;
				var m3 = prop.d;
				var m4 = prop.e;
				return A5(
					author$project$Animation$Model$Property4,
					name,
					fn(m1),
					fn(m2),
					fn(m3),
					fn(m4));
			case 7:
				var name = prop.a;
				var m1 = prop.b;
				return A2(
					author$project$Animation$Model$AngleProperty,
					name,
					fn(m1));
			case 8:
				var ms = prop.a;
				return author$project$Animation$Model$Points(
					A2(
						elm$core$List$map,
						function (_n1) {
							var x = _n1.a;
							var y = _n1.b;
							return _Utils_Tuple2(
								fn(x),
								fn(y));
						},
						ms));
			default:
				var cmds = prop.a;
				return author$project$Animation$Model$Path(
					A2(
						elm$core$List$map,
						author$project$Animation$Model$mapPathMotion(fn),
						cmds));
		}
	});
var author$project$Animation$setDefaultInterpolation = function (prop) {
	var interp = author$project$Animation$defaultInterpolationByProperty(prop);
	return A2(
		author$project$Animation$Model$mapToMotion,
		function (m) {
			return _Utils_update(
				m,
				{ab: interp});
		},
		prop);
};
var author$project$Animation$Model$propertyName = function (prop) {
	switch (prop.$) {
		case 0:
			var name = prop.a;
			return name;
		case 1:
			var name = prop.a;
			return name;
		case 2:
			var name = prop.a;
			return name;
		case 3:
			var name = prop.a;
			return name;
		case 4:
			var name = prop.a;
			return name;
		case 5:
			var name = prop.a;
			return name;
		case 6:
			var name = prop.a;
			return name;
		case 7:
			var name = prop.a;
			return name;
		case 8:
			return 'points';
		default:
			return 'path';
	}
};
var author$project$Animation$Render$dropWhile = F2(
	function (predicate, list) {
		dropWhile:
		while (true) {
			if (!list.b) {
				return _List_Nil;
			} else {
				var x = list.a;
				var xs = list.b;
				if (predicate(x)) {
					var $temp$predicate = predicate,
						$temp$list = xs;
					predicate = $temp$predicate;
					list = $temp$list;
					continue dropWhile;
				} else {
					return list;
				}
			}
		}
	});
var author$project$Animation$Render$takeWhile = function (predicate) {
	var takeWhileMemo = F2(
		function (memo, list) {
			if (!list.b) {
				return elm$core$List$reverse(memo);
			} else {
				var x = list.a;
				var xs = list.b;
				return predicate(x) ? A2(
					takeWhileMemo,
					A2(elm$core$List$cons, x, memo),
					xs) : elm$core$List$reverse(memo);
			}
		});
	return takeWhileMemo(_List_Nil);
};
var author$project$Animation$Render$span = F2(
	function (p, xs) {
		return _Utils_Tuple2(
			A2(author$project$Animation$Render$takeWhile, p, xs),
			A2(author$project$Animation$Render$dropWhile, p, xs));
	});
var author$project$Animation$Render$groupWhile = F2(
	function (eq, xs_) {
		if (!xs_.b) {
			return _List_Nil;
		} else {
			var x = xs_.a;
			var xs = xs_.b;
			var _n1 = A2(
				author$project$Animation$Render$span,
				eq(x),
				xs);
			var ys = _n1.a;
			var zs = _n1.b;
			return A2(
				elm$core$List$cons,
				A2(elm$core$List$cons, x, ys),
				A2(author$project$Animation$Render$groupWhile, eq, zs));
		}
	});
var elm$core$Basics$True = 0;
var elm$core$List$any = F2(
	function (isOkay, list) {
		any:
		while (true) {
			if (!list.b) {
				return false;
			} else {
				var x = list.a;
				var xs = list.b;
				if (isOkay(x)) {
					return true;
				} else {
					var $temp$isOkay = isOkay,
						$temp$list = xs;
					isOkay = $temp$isOkay;
					list = $temp$list;
					continue any;
				}
			}
		}
	});
var elm$core$List$member = F2(
	function (x, xs) {
		return A2(
			elm$core$List$any,
			function (a) {
				return _Utils_eq(a, x);
			},
			xs);
	});
var author$project$Animation$Render$isTransformation = function (prop) {
	return A2(
		elm$core$List$member,
		author$project$Animation$Model$propertyName(prop),
		_List_fromArray(
			['rotate', 'rotateX', 'rotateY', 'rotateZ', 'rotate3d', 'translate', 'translate3d', 'scale', 'scale3d']));
};
var elm$core$Basics$apR = F2(
	function (x, f) {
		return f(x);
	});
var elm$core$Basics$not = _Basics_not;
var elm$core$List$filter = F2(
	function (isGood, list) {
		return A3(
			elm$core$List$foldr,
			F2(
				function (x, xs) {
					return isGood(x) ? A2(elm$core$List$cons, x, xs) : xs;
				}),
			_List_Nil,
			list);
	});
var elm$core$Maybe$Just = function (a) {
	return {$: 0, a: a};
};
var elm$core$Maybe$Nothing = {$: 1};
var elm$core$List$head = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return elm$core$Maybe$Just(x);
	} else {
		return elm$core$Maybe$Nothing;
	}
};
var elm$core$List$length = function (xs) {
	return A3(
		elm$core$List$foldl,
		F2(
			function (_n0, i) {
				return i + 1;
			}),
		0,
		xs);
};
var elm$core$List$sortBy = _List_sortBy;
var elm$core$List$sort = function (xs) {
	return A2(elm$core$List$sortBy, elm$core$Basics$identity, xs);
};
var author$project$Animation$Render$warnForDoubleListedProperties = function (props) {
	var _n0 = A2(
		elm$core$List$map,
		function (propGroup) {
			var _n1 = elm$core$List$head(propGroup);
			if (_n1.$ === 1) {
				return '';
			} else {
				var name = _n1.a;
				return (elm$core$List$length(propGroup) > 1) ? '' : '';
			}
		},
		A2(
			author$project$Animation$Render$groupWhile,
			elm$core$Basics$eq,
			elm$core$List$sort(
				A2(
					elm$core$List$map,
					author$project$Animation$Model$propertyName,
					A2(
						elm$core$List$filter,
						function (prop) {
							return !author$project$Animation$Render$isTransformation(prop);
						},
						props)))));
	return props;
};
var author$project$Animation$style = function (props) {
	return author$project$Animation$initialState(
		A2(
			elm$core$List$map,
			author$project$Animation$setDefaultInterpolation,
			author$project$Animation$Render$warnForDoubleListedProperties(props)));
};
var author$project$Animation$initMotion = F2(
	function (position, unit) {
		return {
			ab: author$project$Animation$Model$Spring(
				{bi: 26, bO: 170}),
			cI: elm$core$Maybe$Nothing,
			cZ: position,
			df: position,
			dx: unit,
			dz: 0
		};
	});
var elm$core$Basics$toFloat = _Basics_toFloat;
var author$project$Animation$customColor = F2(
	function (name, _n0) {
		var red = _n0.m;
		var green = _n0.l;
		var blue = _n0.j;
		var alpha = _n0.i;
		return A5(
			author$project$Animation$Model$ColorProperty,
			name,
			A2(author$project$Animation$initMotion, red, ''),
			A2(author$project$Animation$initMotion, green, ''),
			A2(author$project$Animation$initMotion, blue, ''),
			A2(author$project$Animation$initMotion, alpha, ''));
	});
var author$project$Animation$fill = function (clr) {
	return A2(author$project$Animation$customColor, 'fill', clr);
};
var elm$core$Basics$append = _Utils_append;
var elm$core$Basics$le = _Utils_le;
var elm$core$Basics$sub = _Basics_sub;
var elm$core$List$drop = F2(
	function (n, list) {
		drop:
		while (true) {
			if (n <= 0) {
				return list;
			} else {
				if (!list.b) {
					return list;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs;
					n = $temp$n;
					list = $temp$list;
					continue drop;
				}
			}
		}
	});
var elm$core$List$maybeCons = F3(
	function (f, mx, xs) {
		var _n0 = f(mx);
		if (!_n0.$) {
			var x = _n0.a;
			return A2(elm$core$List$cons, x, xs);
		} else {
			return xs;
		}
	});
var elm$core$List$filterMap = F2(
	function (f, xs) {
		return A3(
			elm$core$List$foldr,
			elm$core$List$maybeCons(f),
			_List_Nil,
			xs);
	});
var elm$core$List$map2 = _List_map2;
var elm$core$List$rangeHelp = F3(
	function (lo, hi, list) {
		rangeHelp:
		while (true) {
			if (_Utils_cmp(lo, hi) < 1) {
				var $temp$lo = lo,
					$temp$hi = hi - 1,
					$temp$list = A2(elm$core$List$cons, hi, list);
				lo = $temp$lo;
				hi = $temp$hi;
				list = $temp$list;
				continue rangeHelp;
			} else {
				return list;
			}
		}
	});
var elm$core$List$range = F2(
	function (lo, hi) {
		return A3(elm$core$List$rangeHelp, lo, hi, _List_Nil);
	});
var elm$core$List$indexedMap = F2(
	function (f, xs) {
		return A3(
			elm$core$List$map2,
			f,
			A2(
				elm$core$List$range,
				0,
				elm$core$List$length(xs) - 1),
			xs);
	});
var elm$core$Basics$lt = _Utils_lt;
var elm$core$Basics$min = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) < 0) ? x : y;
	});
var elm$core$List$minimum = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return elm$core$Maybe$Just(
			A3(elm$core$List$foldl, elm$core$Basics$min, x, xs));
	} else {
		return elm$core$Maybe$Nothing;
	}
};
var elm$core$List$takeReverse = F3(
	function (n, list, kept) {
		takeReverse:
		while (true) {
			if (n <= 0) {
				return kept;
			} else {
				if (!list.b) {
					return kept;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs,
						$temp$kept = A2(elm$core$List$cons, x, kept);
					n = $temp$n;
					list = $temp$list;
					kept = $temp$kept;
					continue takeReverse;
				}
			}
		}
	});
var elm$core$List$takeTailRec = F2(
	function (n, list) {
		return elm$core$List$reverse(
			A3(elm$core$List$takeReverse, n, list, _List_Nil));
	});
var elm$core$List$takeFast = F3(
	function (ctr, n, list) {
		if (n <= 0) {
			return _List_Nil;
		} else {
			var _n0 = _Utils_Tuple2(n, list);
			_n0$1:
			while (true) {
				_n0$5:
				while (true) {
					if (!_n0.b.b) {
						return list;
					} else {
						if (_n0.b.b.b) {
							switch (_n0.a) {
								case 1:
									break _n0$1;
								case 2:
									var _n2 = _n0.b;
									var x = _n2.a;
									var _n3 = _n2.b;
									var y = _n3.a;
									return _List_fromArray(
										[x, y]);
								case 3:
									if (_n0.b.b.b.b) {
										var _n4 = _n0.b;
										var x = _n4.a;
										var _n5 = _n4.b;
										var y = _n5.a;
										var _n6 = _n5.b;
										var z = _n6.a;
										return _List_fromArray(
											[x, y, z]);
									} else {
										break _n0$5;
									}
								default:
									if (_n0.b.b.b.b && _n0.b.b.b.b.b) {
										var _n7 = _n0.b;
										var x = _n7.a;
										var _n8 = _n7.b;
										var y = _n8.a;
										var _n9 = _n8.b;
										var z = _n9.a;
										var _n10 = _n9.b;
										var w = _n10.a;
										var tl = _n10.b;
										return (ctr > 1000) ? A2(
											elm$core$List$cons,
											x,
											A2(
												elm$core$List$cons,
												y,
												A2(
													elm$core$List$cons,
													z,
													A2(
														elm$core$List$cons,
														w,
														A2(elm$core$List$takeTailRec, n - 4, tl))))) : A2(
											elm$core$List$cons,
											x,
											A2(
												elm$core$List$cons,
												y,
												A2(
													elm$core$List$cons,
													z,
													A2(
														elm$core$List$cons,
														w,
														A3(elm$core$List$takeFast, ctr + 1, n - 4, tl)))));
									} else {
										break _n0$5;
									}
							}
						} else {
							if (_n0.a === 1) {
								break _n0$1;
							} else {
								break _n0$5;
							}
						}
					}
				}
				return list;
			}
			var _n1 = _n0.b;
			var x = _n1.a;
			return _List_fromArray(
				[x]);
		}
	});
var elm$core$List$take = F2(
	function (n, list) {
		return A3(elm$core$List$takeFast, 0, n, list);
	});
var author$project$Animation$alignStartingPoint = function (pnts) {
	var sums = A2(
		elm$core$List$map,
		function (_n2) {
			var x_ = _n2.a;
			var y_ = _n2.b;
			return x_ + y_;
		},
		pnts);
	var maybeMin = elm$core$List$minimum(sums);
	var indexOfLowestPoint = function () {
		if (maybeMin.$ === 1) {
			return elm$core$Maybe$Nothing;
		} else {
			var min = maybeMin.a;
			return elm$core$List$head(
				A2(
					elm$core$List$filterMap,
					elm$core$Basics$identity,
					A2(
						elm$core$List$indexedMap,
						F2(
							function (i, val) {
								return _Utils_eq(val, min) ? elm$core$Maybe$Just(i) : elm$core$Maybe$Nothing;
							}),
						sums)));
		}
	}();
	if (indexOfLowestPoint.$ === 1) {
		return pnts;
	} else {
		var i = indexOfLowestPoint.a;
		return _Utils_ap(
			A2(elm$core$List$drop, i, pnts),
			A2(elm$core$List$take, i, pnts));
	}
};
var author$project$Animation$points = function (pnts) {
	return author$project$Animation$Model$Points(
		A2(
			elm$core$List$map,
			function (_n0) {
				var x_ = _n0.a;
				var y_ = _n0.b;
				return _Utils_Tuple2(
					A2(author$project$Animation$initMotion, x_, ''),
					A2(author$project$Animation$initMotion, y_, ''));
			},
			author$project$Animation$alignStartingPoint(pnts)));
};
var author$project$Style$rgb = F3(
	function (red, green, blue) {
		return {i: 1.0, j: blue, l: green, m: red};
	});
var author$project$Style$animationPalette = {
	bb: A3(author$project$Style$rgb, 0, 23, 31),
	bp: A3(author$project$Style$rgb, 0, 168, 232),
	cz: A3(author$project$Style$rgb, 0, 52, 89),
	cL: A3(author$project$Style$rgb, 0, 126, 167),
	bu: A3(author$project$Style$rgb, 216, 219, 226),
	aI: A3(author$project$Style$rgb, 255, 255, 255)
};
var author$project$ElmLogo$polygons = _List_fromArray(
	[
		_List_fromArray(
		[
			author$project$Animation$points(
			_List_fromArray(
				[
					_Utils_Tuple2(168, 163.5),
					_Utils_Tuple2(245.298, 240.432),
					_Utils_Tuple2(323.298, 160.375),
					_Utils_Tuple2(245.213, 83.375)
				])),
			author$project$Animation$fill(author$project$Style$animationPalette.bb)
		]),
		_List_fromArray(
		[
			author$project$Animation$points(
			_List_fromArray(
				[
					_Utils_Tuple2(161.649, 152.782),
					_Utils_Tuple2(231.514, 82.916),
					_Utils_Tuple2(91.783, 82.916)
				])),
			author$project$Animation$fill(author$project$Style$animationPalette.bu)
		]),
		_List_fromArray(
		[
			author$project$Animation$points(
			_List_fromArray(
				[
					_Utils_Tuple2(8.867, 0),
					_Utils_Tuple2(79.241, 70.375),
					_Utils_Tuple2(232.213, 70.375),
					_Utils_Tuple2(161.838, 0)
				])),
			author$project$Animation$fill(author$project$Style$animationPalette.bb)
		]),
		_List_fromArray(
		[
			author$project$Animation$points(
			_List_fromArray(
				[
					_Utils_Tuple2(323.298, 143.724),
					_Utils_Tuple2(323.298, 0),
					_Utils_Tuple2(179.573, 0)
				])),
			author$project$Animation$fill(author$project$Style$animationPalette.bp)
		]),
		_List_fromArray(
		[
			author$project$Animation$points(
			_List_fromArray(
				[
					_Utils_Tuple2(152.781, 161.649),
					_Utils_Tuple2(0, 8.868),
					_Utils_Tuple2(0, 314.432)
				])),
			author$project$Animation$fill(author$project$Style$animationPalette.cL)
		]),
		_List_fromArray(
		[
			author$project$Animation$points(
			_List_fromArray(
				[
					_Utils_Tuple2(255.522, 246.655),
					_Utils_Tuple2(323.298, 314.432),
					_Utils_Tuple2(323.298, 178.879)
				])),
			author$project$Animation$fill(author$project$Style$animationPalette.bu)
		]),
		_List_fromArray(
		[
			author$project$Animation$points(
			_List_fromArray(
				[
					_Utils_Tuple2(161.649, 170.517),
					_Utils_Tuple2(8.869, 323.298),
					_Utils_Tuple2(314.43, 323.298)
				])),
			author$project$Animation$fill(author$project$Style$animationPalette.bp)
		])
	]);
var author$project$Main$Home = 0;
var author$project$Main$InitialViewport = function (a) {
	return {$: 1, a: a};
};
var author$project$Main$WhyElm = 1;
var elm$time$Time$posixToMillis = function (_n0) {
	var millis = _n0;
	return millis;
};
var author$project$Animation$extractInitialWait = function (steps) {
	var _n0 = elm$core$List$head(steps);
	if (_n0.$ === 1) {
		return _Utils_Tuple2(
			elm$time$Time$millisToPosix(0),
			_List_Nil);
	} else {
		var step = _n0.a;
		if (step.$ === 4) {
			var till = step.a;
			var _n2 = author$project$Animation$extractInitialWait(
				A2(elm$core$List$drop, 1, steps));
			var additionalTime = _n2.a;
			var remainingSteps = _n2.b;
			return _Utils_Tuple2(
				elm$time$Time$millisToPosix(
					elm$time$Time$posixToMillis(till) + elm$time$Time$posixToMillis(additionalTime)),
				remainingSteps);
		} else {
			return _Utils_Tuple2(
				elm$time$Time$millisToPosix(0),
				steps);
		}
	}
};
var author$project$Animation$interrupt = F2(
	function (steps, _n0) {
		var model = _n0;
		return _Utils_update(
			model,
			{
				aZ: A2(
					elm$core$List$cons,
					author$project$Animation$extractInitialWait(steps),
					model.aZ),
				aM: true
			});
	});
var author$project$Animation$custom = F3(
	function (name, value, unit) {
		return A2(
			author$project$Animation$Model$Property,
			name,
			A2(author$project$Animation$initMotion, value, unit));
	});
var author$project$Animation$scale = function (valX) {
	return A3(author$project$Animation$custom, 'scale', valX, '');
};
var author$project$Animation$Model$Set = function (a) {
	return {$: 3, a: a};
};
var author$project$Animation$set = function (props) {
	return author$project$Animation$Model$Set(props);
};
var author$project$Animation$Model$To = function (a) {
	return {$: 1, a: a};
};
var author$project$Animation$to = function (props) {
	return author$project$Animation$Model$To(props);
};
var author$project$Animation$Model$Wait = function (a) {
	return {$: 4, a: a};
};
var author$project$Animation$wait = function (till) {
	return author$project$Animation$Model$Wait(till);
};
var author$project$Main$second = 1000;
var author$project$Animation$Length = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var author$project$Animation$Px = 1;
var author$project$Animation$px = function (myPx) {
	return A2(author$project$Animation$Length, myPx, 1);
};
var author$project$Animation$length2 = F3(
	function (name, _n0, _n1) {
		var val = _n0.a;
		var len = _n0.b;
		var val2 = _n1.a;
		var len2 = _n1.b;
		return A3(
			author$project$Animation$Model$Property2,
			name,
			A2(author$project$Animation$initMotion, val, len),
			A2(author$project$Animation$initMotion, val2, len2));
	});
var author$project$Animation$lengthUnitName = function (unit) {
	switch (unit) {
		case 0:
			return '';
		case 1:
			return 'px';
		case 2:
			return '%';
		case 3:
			return 'rem';
		case 4:
			return 'em';
		case 5:
			return 'ex';
		case 6:
			return 'ch';
		case 7:
			return 'vh';
		case 8:
			return 'vw';
		case 9:
			return 'vmin';
		case 10:
			return 'vmax';
		case 11:
			return 'mm';
		case 12:
			return 'cm';
		case 13:
			return 'in';
		case 14:
			return 'pt';
		default:
			return 'pc';
	}
};
var author$project$Animation$translate = F2(
	function (_n0, _n1) {
		var valX = _n0.a;
		var len1 = _n0.b;
		var valY = _n1.a;
		var len2 = _n1.b;
		return A3(
			author$project$Animation$length2,
			'translate',
			_Utils_Tuple2(
				valX,
				author$project$Animation$lengthUnitName(len1)),
			_Utils_Tuple2(
				valY,
				author$project$Animation$lengthUnitName(len2)));
	});
var author$project$Main$translate = function (n) {
	return A2(
		author$project$Animation$translate,
		author$project$Animation$px(n),
		author$project$Animation$px(n));
};
var elm$core$Basics$fdiv = _Basics_fdiv;
var elm$core$Basics$mul = _Basics_mul;
var elm$core$Basics$negate = function (n) {
	return -n;
};
var elm$core$Basics$round = _Basics_round;
var author$project$Main$makeTranslated = F2(
	function (i, polygon) {
		return A2(
			author$project$Animation$interrupt,
			_List_fromArray(
				[
					author$project$Animation$set(
					_List_fromArray(
						[
							author$project$Main$translate(-1000),
							author$project$Animation$scale(1)
						])),
					author$project$Animation$wait(
					elm$time$Time$millisToPosix(
						elm$core$Basics$round(((author$project$Main$second * i) * 0.1) + ((((i * i) * author$project$Main$second) * 5.0e-2) / (i + 1))))),
					author$project$Animation$to(
					_List_fromArray(
						[
							author$project$Main$translate(0),
							author$project$Animation$scale(1)
						]))
				]),
			polygon);
	});
var author$project$Main$updateStyles = function (model) {
	return _Utils_update(
		model,
		{
			M: A2(elm$core$List$indexedMap, author$project$Main$makeTranslated, model.M)
		});
};
var elm$browser$Browser$External = function (a) {
	return {$: 1, a: a};
};
var elm$browser$Browser$Internal = function (a) {
	return {$: 0, a: a};
};
var elm$browser$Browser$Dom$NotFound = elm$core$Basics$identity;
var elm$core$Basics$never = function (_n0) {
	never:
	while (true) {
		var nvr = _n0;
		var $temp$_n0 = nvr;
		_n0 = $temp$_n0;
		continue never;
	}
};
var elm$core$Result$isOk = function (result) {
	if (!result.$) {
		return true;
	} else {
		return false;
	}
};
var elm$core$Task$Perform = elm$core$Basics$identity;
var elm$core$Task$succeed = _Scheduler_succeed;
var elm$core$Task$init = elm$core$Task$succeed(0);
var elm$core$Task$andThen = _Scheduler_andThen;
var elm$core$Task$map = F2(
	function (func, taskA) {
		return A2(
			elm$core$Task$andThen,
			function (a) {
				return elm$core$Task$succeed(
					func(a));
			},
			taskA);
	});
var elm$core$Task$map2 = F3(
	function (func, taskA, taskB) {
		return A2(
			elm$core$Task$andThen,
			function (a) {
				return A2(
					elm$core$Task$andThen,
					function (b) {
						return elm$core$Task$succeed(
							A2(func, a, b));
					},
					taskB);
			},
			taskA);
	});
var elm$core$Task$sequence = function (tasks) {
	return A3(
		elm$core$List$foldr,
		elm$core$Task$map2(elm$core$List$cons),
		elm$core$Task$succeed(_List_Nil),
		tasks);
};
var elm$core$Array$branchFactor = 32;
var elm$core$Array$Array_elm_builtin = F4(
	function (a, b, c, d) {
		return {$: 0, a: a, b: b, c: c, d: d};
	});
var elm$core$Basics$ceiling = _Basics_ceiling;
var elm$core$Basics$logBase = F2(
	function (base, number) {
		return _Basics_log(number) / _Basics_log(base);
	});
var elm$core$Array$shiftStep = elm$core$Basics$ceiling(
	A2(elm$core$Basics$logBase, 2, elm$core$Array$branchFactor));
var elm$core$Elm$JsArray$empty = _JsArray_empty;
var elm$core$Array$empty = A4(elm$core$Array$Array_elm_builtin, 0, elm$core$Array$shiftStep, elm$core$Elm$JsArray$empty, elm$core$Elm$JsArray$empty);
var elm$core$Array$Leaf = function (a) {
	return {$: 1, a: a};
};
var elm$core$Array$SubTree = function (a) {
	return {$: 0, a: a};
};
var elm$core$Elm$JsArray$initializeFromList = _JsArray_initializeFromList;
var elm$core$Array$compressNodes = F2(
	function (nodes, acc) {
		compressNodes:
		while (true) {
			var _n0 = A2(elm$core$Elm$JsArray$initializeFromList, elm$core$Array$branchFactor, nodes);
			var node = _n0.a;
			var remainingNodes = _n0.b;
			var newAcc = A2(
				elm$core$List$cons,
				elm$core$Array$SubTree(node),
				acc);
			if (!remainingNodes.b) {
				return elm$core$List$reverse(newAcc);
			} else {
				var $temp$nodes = remainingNodes,
					$temp$acc = newAcc;
				nodes = $temp$nodes;
				acc = $temp$acc;
				continue compressNodes;
			}
		}
	});
var elm$core$Array$treeFromBuilder = F2(
	function (nodeList, nodeListSize) {
		treeFromBuilder:
		while (true) {
			var newNodeSize = elm$core$Basics$ceiling(nodeListSize / elm$core$Array$branchFactor);
			if (newNodeSize === 1) {
				return A2(elm$core$Elm$JsArray$initializeFromList, elm$core$Array$branchFactor, nodeList).a;
			} else {
				var $temp$nodeList = A2(elm$core$Array$compressNodes, nodeList, _List_Nil),
					$temp$nodeListSize = newNodeSize;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue treeFromBuilder;
			}
		}
	});
var elm$core$Basics$floor = _Basics_floor;
var elm$core$Basics$max = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) > 0) ? x : y;
	});
var elm$core$Elm$JsArray$length = _JsArray_length;
var elm$core$Array$builderToArray = F2(
	function (reverseNodeList, builder) {
		if (!builder.a) {
			return A4(
				elm$core$Array$Array_elm_builtin,
				elm$core$Elm$JsArray$length(builder.c),
				elm$core$Array$shiftStep,
				elm$core$Elm$JsArray$empty,
				builder.c);
		} else {
			var treeLen = builder.a * elm$core$Array$branchFactor;
			var depth = elm$core$Basics$floor(
				A2(elm$core$Basics$logBase, elm$core$Array$branchFactor, treeLen - 1));
			var correctNodeList = reverseNodeList ? elm$core$List$reverse(builder.e) : builder.e;
			var tree = A2(elm$core$Array$treeFromBuilder, correctNodeList, builder.a);
			return A4(
				elm$core$Array$Array_elm_builtin,
				elm$core$Elm$JsArray$length(builder.c) + treeLen,
				A2(elm$core$Basics$max, 5, depth * elm$core$Array$shiftStep),
				tree,
				builder.c);
		}
	});
var elm$core$Basics$idiv = _Basics_idiv;
var elm$core$Elm$JsArray$initialize = _JsArray_initialize;
var elm$core$Array$initializeHelp = F5(
	function (fn, fromIndex, len, nodeList, tail) {
		initializeHelp:
		while (true) {
			if (fromIndex < 0) {
				return A2(
					elm$core$Array$builderToArray,
					false,
					{e: nodeList, a: (len / elm$core$Array$branchFactor) | 0, c: tail});
			} else {
				var leaf = elm$core$Array$Leaf(
					A3(elm$core$Elm$JsArray$initialize, elm$core$Array$branchFactor, fromIndex, fn));
				var $temp$fn = fn,
					$temp$fromIndex = fromIndex - elm$core$Array$branchFactor,
					$temp$len = len,
					$temp$nodeList = A2(elm$core$List$cons, leaf, nodeList),
					$temp$tail = tail;
				fn = $temp$fn;
				fromIndex = $temp$fromIndex;
				len = $temp$len;
				nodeList = $temp$nodeList;
				tail = $temp$tail;
				continue initializeHelp;
			}
		}
	});
var elm$core$Basics$remainderBy = _Basics_remainderBy;
var elm$core$Array$initialize = F2(
	function (len, fn) {
		if (len <= 0) {
			return elm$core$Array$empty;
		} else {
			var tailLen = len % elm$core$Array$branchFactor;
			var tail = A3(elm$core$Elm$JsArray$initialize, tailLen, len - tailLen, fn);
			var initialFromIndex = (len - tailLen) - elm$core$Array$branchFactor;
			return A5(elm$core$Array$initializeHelp, fn, initialFromIndex, len, _List_Nil, tail);
		}
	});
var elm$core$Result$Err = function (a) {
	return {$: 1, a: a};
};
var elm$core$Result$Ok = function (a) {
	return {$: 0, a: a};
};
var elm$json$Json$Decode$Failure = F2(
	function (a, b) {
		return {$: 3, a: a, b: b};
	});
var elm$json$Json$Decode$Field = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var elm$json$Json$Decode$Index = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var elm$json$Json$Decode$OneOf = function (a) {
	return {$: 2, a: a};
};
var elm$core$Platform$sendToApp = _Platform_sendToApp;
var elm$core$Task$spawnCmd = F2(
	function (router, _n0) {
		var task = _n0;
		return _Scheduler_spawn(
			A2(
				elm$core$Task$andThen,
				elm$core$Platform$sendToApp(router),
				task));
	});
var elm$core$Task$onEffects = F3(
	function (router, commands, state) {
		return A2(
			elm$core$Task$map,
			function (_n0) {
				return 0;
			},
			elm$core$Task$sequence(
				A2(
					elm$core$List$map,
					elm$core$Task$spawnCmd(router),
					commands)));
	});
var elm$core$Task$onSelfMsg = F3(
	function (_n0, _n1, _n2) {
		return elm$core$Task$succeed(0);
	});
var elm$core$Task$cmdMap = F2(
	function (tagger, _n0) {
		var task = _n0;
		return A2(elm$core$Task$map, tagger, task);
	});
_Platform_effectManagers['Task'] = _Platform_createManager(elm$core$Task$init, elm$core$Task$onEffects, elm$core$Task$onSelfMsg, elm$core$Task$cmdMap);
var elm$core$Task$command = _Platform_leaf('Task');
var elm$core$Task$perform = F2(
	function (toMessage, task) {
		return elm$core$Task$command(
			A2(elm$core$Task$map, toMessage, task));
	});
var elm$json$Json$Decode$map = _Json_map1;
var elm$json$Json$Decode$map2 = _Json_map2;
var elm$json$Json$Decode$succeed = _Json_succeed;
var elm$virtual_dom$VirtualDom$toHandlerInt = function (handler) {
	switch (handler.$) {
		case 0:
			return 0;
		case 1:
			return 1;
		case 2:
			return 2;
		default:
			return 3;
	}
};
var elm$core$String$length = _String_length;
var elm$core$String$slice = _String_slice;
var elm$core$String$dropLeft = F2(
	function (n, string) {
		return (n < 1) ? string : A3(
			elm$core$String$slice,
			n,
			elm$core$String$length(string),
			string);
	});
var elm$core$String$startsWith = _String_startsWith;
var elm$url$Url$Http = 0;
var elm$url$Url$Https = 1;
var elm$core$String$indexes = _String_indexes;
var elm$core$String$isEmpty = function (string) {
	return string === '';
};
var elm$core$String$left = F2(
	function (n, string) {
		return (n < 1) ? '' : A3(elm$core$String$slice, 0, n, string);
	});
var elm$core$Basics$or = _Basics_or;
var elm$core$String$contains = _String_contains;
var elm$core$String$toInt = _String_toInt;
var elm$url$Url$Url = F6(
	function (protocol, host, port_, path, query, fragment) {
		return {bm: fragment, bq: host, bA: path, bD: port_, bH: protocol, bI: query};
	});
var elm$url$Url$chompBeforePath = F5(
	function (protocol, path, params, frag, str) {
		if (elm$core$String$isEmpty(str) || A2(elm$core$String$contains, '@', str)) {
			return elm$core$Maybe$Nothing;
		} else {
			var _n0 = A2(elm$core$String$indexes, ':', str);
			if (!_n0.b) {
				return elm$core$Maybe$Just(
					A6(elm$url$Url$Url, protocol, str, elm$core$Maybe$Nothing, path, params, frag));
			} else {
				if (!_n0.b.b) {
					var i = _n0.a;
					var _n1 = elm$core$String$toInt(
						A2(elm$core$String$dropLeft, i + 1, str));
					if (_n1.$ === 1) {
						return elm$core$Maybe$Nothing;
					} else {
						var port_ = _n1;
						return elm$core$Maybe$Just(
							A6(
								elm$url$Url$Url,
								protocol,
								A2(elm$core$String$left, i, str),
								port_,
								path,
								params,
								frag));
					}
				} else {
					return elm$core$Maybe$Nothing;
				}
			}
		}
	});
var elm$url$Url$chompBeforeQuery = F4(
	function (protocol, params, frag, str) {
		if (elm$core$String$isEmpty(str)) {
			return elm$core$Maybe$Nothing;
		} else {
			var _n0 = A2(elm$core$String$indexes, '/', str);
			if (!_n0.b) {
				return A5(elm$url$Url$chompBeforePath, protocol, '/', params, frag, str);
			} else {
				var i = _n0.a;
				return A5(
					elm$url$Url$chompBeforePath,
					protocol,
					A2(elm$core$String$dropLeft, i, str),
					params,
					frag,
					A2(elm$core$String$left, i, str));
			}
		}
	});
var elm$url$Url$chompBeforeFragment = F3(
	function (protocol, frag, str) {
		if (elm$core$String$isEmpty(str)) {
			return elm$core$Maybe$Nothing;
		} else {
			var _n0 = A2(elm$core$String$indexes, '?', str);
			if (!_n0.b) {
				return A4(elm$url$Url$chompBeforeQuery, protocol, elm$core$Maybe$Nothing, frag, str);
			} else {
				var i = _n0.a;
				return A4(
					elm$url$Url$chompBeforeQuery,
					protocol,
					elm$core$Maybe$Just(
						A2(elm$core$String$dropLeft, i + 1, str)),
					frag,
					A2(elm$core$String$left, i, str));
			}
		}
	});
var elm$url$Url$chompAfterProtocol = F2(
	function (protocol, str) {
		if (elm$core$String$isEmpty(str)) {
			return elm$core$Maybe$Nothing;
		} else {
			var _n0 = A2(elm$core$String$indexes, '#', str);
			if (!_n0.b) {
				return A3(elm$url$Url$chompBeforeFragment, protocol, elm$core$Maybe$Nothing, str);
			} else {
				var i = _n0.a;
				return A3(
					elm$url$Url$chompBeforeFragment,
					protocol,
					elm$core$Maybe$Just(
						A2(elm$core$String$dropLeft, i + 1, str)),
					A2(elm$core$String$left, i, str));
			}
		}
	});
var elm$url$Url$fromString = function (str) {
	return A2(elm$core$String$startsWith, 'http://', str) ? A2(
		elm$url$Url$chompAfterProtocol,
		0,
		A2(elm$core$String$dropLeft, 7, str)) : (A2(elm$core$String$startsWith, 'https://', str) ? A2(
		elm$url$Url$chompAfterProtocol,
		1,
		A2(elm$core$String$dropLeft, 8, str)) : elm$core$Maybe$Nothing);
};
var elm$browser$Browser$Dom$getViewport = _Browser_withWindow(_Browser_getViewport);
var elm$core$Basics$and = _Basics_and;
var mdgriffith$stylish_elephants$Element$BigDesktop = 3;
var mdgriffith$stylish_elephants$Element$Desktop = 2;
var mdgriffith$stylish_elephants$Element$Landscape = 1;
var mdgriffith$stylish_elephants$Element$Phone = 0;
var mdgriffith$stylish_elephants$Element$Portrait = 0;
var mdgriffith$stylish_elephants$Element$Tablet = 1;
var mdgriffith$stylish_elephants$Element$classifyDevice = function (window) {
	return {
		be: (window.D <= 600) ? 0 : (((window.D > 600) && (window.D <= 1200)) ? 1 : (((window.D > 1200) && (window.D <= 1800)) ? 2 : 3)),
		by: (_Utils_cmp(window.D, window.G) < 0) ? 0 : 1
	};
};
var author$project$Main$init = F3(
	function (_n0, url, navigationKey) {
		return _Utils_Tuple2(
			author$project$Main$updateStyles(
				{
					_: {
						aU: mdgriffith$stylish_elephants$Element$classifyDevice(
							{G: 0, D: 0}),
						G: 0,
						D: 0
					},
					a_: navigationKey,
					aq: _Utils_eq(
						url.bm,
						elm$core$Maybe$Just('why-elm')) ? 1 : 0,
					M: A2(elm$core$List$map, author$project$Animation$style, author$project$ElmLogo$polygons)
				}),
			A2(elm$core$Task$perform, author$project$Main$InitialViewport, elm$browser$Browser$Dom$getViewport));
	});
var author$project$Animation$isRunning = function (_n0) {
	var model = _n0;
	return model.aM;
};
var author$project$Animation$Model$Tick = elm$core$Basics$identity;
var elm$browser$Browser$AnimationManager$Time = function (a) {
	return {$: 0, a: a};
};
var elm$browser$Browser$AnimationManager$State = F3(
	function (subs, request, oldTime) {
		return {a0: oldTime, bK: request, bQ: subs};
	});
var elm$browser$Browser$AnimationManager$init = elm$core$Task$succeed(
	A3(elm$browser$Browser$AnimationManager$State, _List_Nil, elm$core$Maybe$Nothing, 0));
var elm$browser$Browser$AnimationManager$now = _Browser_now(0);
var elm$browser$Browser$AnimationManager$rAF = _Browser_rAF(0);
var elm$core$Platform$sendToSelf = _Platform_sendToSelf;
var elm$core$Process$kill = _Scheduler_kill;
var elm$core$Process$spawn = _Scheduler_spawn;
var elm$browser$Browser$AnimationManager$onEffects = F3(
	function (router, subs, _n0) {
		var request = _n0.bK;
		var oldTime = _n0.a0;
		var _n1 = _Utils_Tuple2(request, subs);
		if (_n1.a.$ === 1) {
			if (!_n1.b.b) {
				var _n2 = _n1.a;
				return elm$browser$Browser$AnimationManager$init;
			} else {
				var _n4 = _n1.a;
				return A2(
					elm$core$Task$andThen,
					function (pid) {
						return A2(
							elm$core$Task$andThen,
							function (time) {
								return elm$core$Task$succeed(
									A3(
										elm$browser$Browser$AnimationManager$State,
										subs,
										elm$core$Maybe$Just(pid),
										time));
							},
							elm$browser$Browser$AnimationManager$now);
					},
					elm$core$Process$spawn(
						A2(
							elm$core$Task$andThen,
							elm$core$Platform$sendToSelf(router),
							elm$browser$Browser$AnimationManager$rAF)));
			}
		} else {
			if (!_n1.b.b) {
				var pid = _n1.a.a;
				return A2(
					elm$core$Task$andThen,
					function (_n3) {
						return elm$browser$Browser$AnimationManager$init;
					},
					elm$core$Process$kill(pid));
			} else {
				return elm$core$Task$succeed(
					A3(elm$browser$Browser$AnimationManager$State, subs, request, oldTime));
			}
		}
	});
var elm$browser$Browser$AnimationManager$onSelfMsg = F3(
	function (router, newTime, _n0) {
		var subs = _n0.bQ;
		var oldTime = _n0.a0;
		var send = function (sub) {
			if (!sub.$) {
				var tagger = sub.a;
				return A2(
					elm$core$Platform$sendToApp,
					router,
					tagger(
						elm$time$Time$millisToPosix(newTime)));
			} else {
				var tagger = sub.a;
				return A2(
					elm$core$Platform$sendToApp,
					router,
					tagger(newTime - oldTime));
			}
		};
		return A2(
			elm$core$Task$andThen,
			function (pid) {
				return A2(
					elm$core$Task$andThen,
					function (_n1) {
						return elm$core$Task$succeed(
							A3(
								elm$browser$Browser$AnimationManager$State,
								subs,
								elm$core$Maybe$Just(pid),
								newTime));
					},
					elm$core$Task$sequence(
						A2(elm$core$List$map, send, subs)));
			},
			elm$core$Process$spawn(
				A2(
					elm$core$Task$andThen,
					elm$core$Platform$sendToSelf(router),
					elm$browser$Browser$AnimationManager$rAF)));
	});
var elm$browser$Browser$AnimationManager$Delta = function (a) {
	return {$: 1, a: a};
};
var elm$core$Basics$composeL = F3(
	function (g, f, x) {
		return g(
			f(x));
	});
var elm$browser$Browser$AnimationManager$subMap = F2(
	function (func, sub) {
		if (!sub.$) {
			var tagger = sub.a;
			return elm$browser$Browser$AnimationManager$Time(
				A2(elm$core$Basics$composeL, func, tagger));
		} else {
			var tagger = sub.a;
			return elm$browser$Browser$AnimationManager$Delta(
				A2(elm$core$Basics$composeL, func, tagger));
		}
	});
_Platform_effectManagers['Browser.AnimationManager'] = _Platform_createManager(elm$browser$Browser$AnimationManager$init, elm$browser$Browser$AnimationManager$onEffects, elm$browser$Browser$AnimationManager$onSelfMsg, 0, elm$browser$Browser$AnimationManager$subMap);
var elm$browser$Browser$AnimationManager$subscription = _Platform_leaf('Browser.AnimationManager');
var elm$browser$Browser$AnimationManager$onAnimationFrame = function (tagger) {
	return elm$browser$Browser$AnimationManager$subscription(
		elm$browser$Browser$AnimationManager$Time(tagger));
};
var elm$browser$Browser$Events$onAnimationFrame = elm$browser$Browser$AnimationManager$onAnimationFrame;
var elm$core$Platform$Sub$map = _Platform_map;
var elm$core$Platform$Sub$batch = _Platform_batch;
var elm$core$Platform$Sub$none = elm$core$Platform$Sub$batch(_List_Nil);
var author$project$Animation$subscription = F2(
	function (msg, states) {
		return A2(elm$core$List$any, author$project$Animation$isRunning, states) ? A2(
			elm$core$Platform$Sub$map,
			msg,
			elm$browser$Browser$Events$onAnimationFrame(elm$core$Basics$identity)) : elm$core$Platform$Sub$none;
	});
var author$project$Main$Animate = function (a) {
	return {$: 0, a: a};
};
var author$project$Main$WindowResized = F2(
	function (a, b) {
		return {$: 2, a: a, b: b};
	});
var elm$browser$Browser$Events$Window = 1;
var elm$browser$Browser$Events$MySub = F3(
	function (a, b, c) {
		return {$: 0, a: a, b: b, c: c};
	});
var elm$browser$Browser$Events$State = F2(
	function (subs, pids) {
		return {bC: pids, bQ: subs};
	});
var elm$core$Dict$RBEmpty_elm_builtin = {$: -2};
var elm$core$Dict$empty = elm$core$Dict$RBEmpty_elm_builtin;
var elm$browser$Browser$Events$init = elm$core$Task$succeed(
	A2(elm$browser$Browser$Events$State, _List_Nil, elm$core$Dict$empty));
var elm$browser$Browser$Events$nodeToKey = function (node) {
	if (!node) {
		return 'd_';
	} else {
		return 'w_';
	}
};
var elm$browser$Browser$Events$addKey = function (sub) {
	var node = sub.a;
	var name = sub.b;
	return _Utils_Tuple2(
		_Utils_ap(
			elm$browser$Browser$Events$nodeToKey(node),
			name),
		sub);
};
var elm$browser$Browser$Events$Event = F2(
	function (key, event) {
		return {bl: event, a_: key};
	});
var elm$browser$Browser$Events$spawn = F3(
	function (router, key, _n0) {
		var node = _n0.a;
		var name = _n0.b;
		var actualNode = function () {
			if (!node) {
				return _Browser_doc;
			} else {
				return _Browser_window;
			}
		}();
		return A2(
			elm$core$Task$map,
			function (value) {
				return _Utils_Tuple2(key, value);
			},
			A3(
				_Browser_on,
				actualNode,
				name,
				function (event) {
					return A2(
						elm$core$Platform$sendToSelf,
						router,
						A2(elm$browser$Browser$Events$Event, key, event));
				}));
	});
var elm$core$Dict$Black = 1;
var elm$core$Dict$RBNode_elm_builtin = F5(
	function (a, b, c, d, e) {
		return {$: -1, a: a, b: b, c: c, d: d, e: e};
	});
var elm$core$Basics$compare = _Utils_compare;
var elm$core$Dict$Red = 0;
var elm$core$Dict$balance = F5(
	function (color, key, value, left, right) {
		if ((right.$ === -1) && (!right.a)) {
			var _n1 = right.a;
			var rK = right.b;
			var rV = right.c;
			var rLeft = right.d;
			var rRight = right.e;
			if ((left.$ === -1) && (!left.a)) {
				var _n3 = left.a;
				var lK = left.b;
				var lV = left.c;
				var lLeft = left.d;
				var lRight = left.e;
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					0,
					key,
					value,
					A5(elm$core$Dict$RBNode_elm_builtin, 1, lK, lV, lLeft, lRight),
					A5(elm$core$Dict$RBNode_elm_builtin, 1, rK, rV, rLeft, rRight));
			} else {
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					color,
					rK,
					rV,
					A5(elm$core$Dict$RBNode_elm_builtin, 0, key, value, left, rLeft),
					rRight);
			}
		} else {
			if ((((left.$ === -1) && (!left.a)) && (left.d.$ === -1)) && (!left.d.a)) {
				var _n5 = left.a;
				var lK = left.b;
				var lV = left.c;
				var _n6 = left.d;
				var _n7 = _n6.a;
				var llK = _n6.b;
				var llV = _n6.c;
				var llLeft = _n6.d;
				var llRight = _n6.e;
				var lRight = left.e;
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					0,
					lK,
					lV,
					A5(elm$core$Dict$RBNode_elm_builtin, 1, llK, llV, llLeft, llRight),
					A5(elm$core$Dict$RBNode_elm_builtin, 1, key, value, lRight, right));
			} else {
				return A5(elm$core$Dict$RBNode_elm_builtin, color, key, value, left, right);
			}
		}
	});
var elm$core$Dict$insertHelp = F3(
	function (key, value, dict) {
		if (dict.$ === -2) {
			return A5(elm$core$Dict$RBNode_elm_builtin, 0, key, value, elm$core$Dict$RBEmpty_elm_builtin, elm$core$Dict$RBEmpty_elm_builtin);
		} else {
			var nColor = dict.a;
			var nKey = dict.b;
			var nValue = dict.c;
			var nLeft = dict.d;
			var nRight = dict.e;
			var _n1 = A2(elm$core$Basics$compare, key, nKey);
			switch (_n1) {
				case 0:
					return A5(
						elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						A3(elm$core$Dict$insertHelp, key, value, nLeft),
						nRight);
				case 1:
					return A5(elm$core$Dict$RBNode_elm_builtin, nColor, nKey, value, nLeft, nRight);
				default:
					return A5(
						elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						nLeft,
						A3(elm$core$Dict$insertHelp, key, value, nRight));
			}
		}
	});
var elm$core$Dict$insert = F3(
	function (key, value, dict) {
		var _n0 = A3(elm$core$Dict$insertHelp, key, value, dict);
		if ((_n0.$ === -1) && (!_n0.a)) {
			var _n1 = _n0.a;
			var k = _n0.b;
			var v = _n0.c;
			var l = _n0.d;
			var r = _n0.e;
			return A5(elm$core$Dict$RBNode_elm_builtin, 1, k, v, l, r);
		} else {
			var x = _n0;
			return x;
		}
	});
var elm$core$Dict$fromList = function (assocs) {
	return A3(
		elm$core$List$foldl,
		F2(
			function (_n0, dict) {
				var key = _n0.a;
				var value = _n0.b;
				return A3(elm$core$Dict$insert, key, value, dict);
			}),
		elm$core$Dict$empty,
		assocs);
};
var elm$core$Dict$foldl = F3(
	function (func, acc, dict) {
		foldl:
		while (true) {
			if (dict.$ === -2) {
				return acc;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3(elm$core$Dict$foldl, func, acc, left)),
					$temp$dict = right;
				func = $temp$func;
				acc = $temp$acc;
				dict = $temp$dict;
				continue foldl;
			}
		}
	});
var elm$core$Dict$merge = F6(
	function (leftStep, bothStep, rightStep, leftDict, rightDict, initialResult) {
		var stepState = F3(
			function (rKey, rValue, _n0) {
				var list = _n0.a;
				var result = _n0.b;
				if (!list.b) {
					return _Utils_Tuple2(
						list,
						A3(rightStep, rKey, rValue, result));
				} else {
					var _n2 = list.a;
					var lKey = _n2.a;
					var lValue = _n2.b;
					var rest = list.b;
					return (_Utils_cmp(lKey, rKey) < 0) ? A3(
						stepState,
						rKey,
						rValue,
						_Utils_Tuple2(
							rest,
							A3(leftStep, lKey, lValue, result))) : ((_Utils_cmp(lKey, rKey) > 0) ? _Utils_Tuple2(
						list,
						A3(rightStep, rKey, rValue, result)) : _Utils_Tuple2(
						rest,
						A4(bothStep, lKey, lValue, rValue, result)));
				}
			});
		var _n3 = A3(
			elm$core$Dict$foldl,
			stepState,
			_Utils_Tuple2(
				elm$core$Dict$toList(leftDict),
				initialResult),
			rightDict);
		var leftovers = _n3.a;
		var intermediateResult = _n3.b;
		return A3(
			elm$core$List$foldl,
			F2(
				function (_n4, result) {
					var k = _n4.a;
					var v = _n4.b;
					return A3(leftStep, k, v, result);
				}),
			intermediateResult,
			leftovers);
	});
var elm$core$Dict$union = F2(
	function (t1, t2) {
		return A3(elm$core$Dict$foldl, elm$core$Dict$insert, t2, t1);
	});
var elm$browser$Browser$Events$onEffects = F3(
	function (router, subs, state) {
		var stepRight = F3(
			function (key, sub, _n6) {
				var deads = _n6.a;
				var lives = _n6.b;
				var news = _n6.c;
				return _Utils_Tuple3(
					deads,
					lives,
					A2(
						elm$core$List$cons,
						A3(elm$browser$Browser$Events$spawn, router, key, sub),
						news));
			});
		var stepLeft = F3(
			function (_n4, pid, _n5) {
				var deads = _n5.a;
				var lives = _n5.b;
				var news = _n5.c;
				return _Utils_Tuple3(
					A2(elm$core$List$cons, pid, deads),
					lives,
					news);
			});
		var stepBoth = F4(
			function (key, pid, _n2, _n3) {
				var deads = _n3.a;
				var lives = _n3.b;
				var news = _n3.c;
				return _Utils_Tuple3(
					deads,
					A3(elm$core$Dict$insert, key, pid, lives),
					news);
			});
		var newSubs = A2(elm$core$List$map, elm$browser$Browser$Events$addKey, subs);
		var _n0 = A6(
			elm$core$Dict$merge,
			stepLeft,
			stepBoth,
			stepRight,
			state.bC,
			elm$core$Dict$fromList(newSubs),
			_Utils_Tuple3(_List_Nil, elm$core$Dict$empty, _List_Nil));
		var deadPids = _n0.a;
		var livePids = _n0.b;
		var makeNewPids = _n0.c;
		return A2(
			elm$core$Task$andThen,
			function (pids) {
				return elm$core$Task$succeed(
					A2(
						elm$browser$Browser$Events$State,
						newSubs,
						A2(
							elm$core$Dict$union,
							livePids,
							elm$core$Dict$fromList(pids))));
			},
			A2(
				elm$core$Task$andThen,
				function (_n1) {
					return elm$core$Task$sequence(makeNewPids);
				},
				elm$core$Task$sequence(
					A2(elm$core$List$map, elm$core$Process$kill, deadPids))));
	});
var elm$browser$Browser$Events$onSelfMsg = F3(
	function (router, _n0, state) {
		var key = _n0.a_;
		var event = _n0.bl;
		var toMessage = function (_n2) {
			var subKey = _n2.a;
			var _n3 = _n2.b;
			var node = _n3.a;
			var name = _n3.b;
			var decoder = _n3.c;
			return _Utils_eq(subKey, key) ? A2(_Browser_decodeEvent, decoder, event) : elm$core$Maybe$Nothing;
		};
		var messages = A2(elm$core$List$filterMap, toMessage, state.bQ);
		return A2(
			elm$core$Task$andThen,
			function (_n1) {
				return elm$core$Task$succeed(state);
			},
			elm$core$Task$sequence(
				A2(
					elm$core$List$map,
					elm$core$Platform$sendToApp(router),
					messages)));
	});
var elm$browser$Browser$Events$subMap = F2(
	function (func, _n0) {
		var node = _n0.a;
		var name = _n0.b;
		var decoder = _n0.c;
		return A3(
			elm$browser$Browser$Events$MySub,
			node,
			name,
			A2(elm$json$Json$Decode$map, func, decoder));
	});
_Platform_effectManagers['Browser.Events'] = _Platform_createManager(elm$browser$Browser$Events$init, elm$browser$Browser$Events$onEffects, elm$browser$Browser$Events$onSelfMsg, 0, elm$browser$Browser$Events$subMap);
var elm$browser$Browser$Events$subscription = _Platform_leaf('Browser.Events');
var elm$browser$Browser$Events$on = F3(
	function (node, name, decoder) {
		return elm$browser$Browser$Events$subscription(
			A3(elm$browser$Browser$Events$MySub, node, name, decoder));
	});
var elm$json$Json$Decode$field = _Json_decodeField;
var elm$json$Json$Decode$int = _Json_decodeInt;
var elm$browser$Browser$Events$onResize = function (func) {
	return A3(
		elm$browser$Browser$Events$on,
		1,
		'resize',
		A2(
			elm$json$Json$Decode$field,
			'target',
			A3(
				elm$json$Json$Decode$map2,
				func,
				A2(elm$json$Json$Decode$field, 'innerWidth', elm$json$Json$Decode$int),
				A2(elm$json$Json$Decode$field, 'innerHeight', elm$json$Json$Decode$int))));
};
var author$project$Main$subscriptions = function (model) {
	return elm$core$Platform$Sub$batch(
		_List_fromArray(
			[
				A2(author$project$Animation$subscription, author$project$Main$Animate, model.M),
				elm$browser$Browser$Events$onResize(author$project$Main$WindowResized)
			]));
};
var author$project$Animation$Model$refreshTiming = F2(
	function (now, timing) {
		var dt = elm$time$Time$posixToMillis(now) - elm$time$Time$posixToMillis(timing.bh);
		return {
			bh: now,
			cq: ((dt > 34) || (!elm$time$Time$posixToMillis(timing.bh))) ? elm$time$Time$millisToPosix(
				elm$core$Basics$round(16.666)) : elm$time$Time$millisToPosix(dt)
		};
	});
var author$project$Animation$Model$Loop = function (a) {
	return {$: 7, a: a};
};
var author$project$Animation$Model$Repeat = F2(
	function (a, b) {
		return {$: 6, a: a, b: b};
	});
var author$project$Animation$Model$Step = {$: 0};
var elm$core$List$all = F2(
	function (isOkay, list) {
		return !A2(
			elm$core$List$any,
			A2(elm$core$Basics$composeL, elm$core$Basics$not, isOkay),
			list);
	});
var author$project$Animation$Model$isCmdDone = function (cmd) {
	var motionDone = function (motion) {
		return (!motion.dz) && _Utils_eq(motion.cZ, motion.df);
	};
	switch (cmd.$) {
		case 0:
			var m1 = cmd.a;
			var m2 = cmd.b;
			return motionDone(m1) && motionDone(m2);
		case 1:
			var m1 = cmd.a;
			var m2 = cmd.b;
			return motionDone(m1) && motionDone(m2);
		case 2:
			var m1 = cmd.a;
			var m2 = cmd.b;
			return motionDone(m1) && motionDone(m2);
		case 3:
			var m1 = cmd.a;
			var m2 = cmd.b;
			return motionDone(m1) && motionDone(m2);
		case 4:
			var motion = cmd.a;
			return motionDone(motion);
		case 5:
			var motion = cmd.a;
			return motionDone(motion);
		case 6:
			var motion = cmd.a;
			return motionDone(motion);
		case 7:
			var motion = cmd.a;
			return motionDone(motion);
		case 8:
			var control1 = cmd.a.ak;
			var control2 = cmd.a.al;
			var point = cmd.a.w;
			return motionDone(control1.a) && (motionDone(control1.b) && (motionDone(control2.a) && (motionDone(control2.b) && (motionDone(point.a) && motionDone(point.b)))));
		case 9:
			var control1 = cmd.a.ak;
			var control2 = cmd.a.al;
			var point = cmd.a.w;
			return motionDone(control1.a) && (motionDone(control1.b) && (motionDone(control2.a) && (motionDone(control2.b) && (motionDone(point.a) && motionDone(point.b)))));
		case 10:
			var control = cmd.a.aj;
			var point = cmd.a.w;
			return motionDone(control.a) && (motionDone(control.b) && (motionDone(point.a) && motionDone(point.b)));
		case 11:
			var control = cmd.a.aj;
			var point = cmd.a.w;
			return motionDone(control.a) && (motionDone(control.b) && (motionDone(point.a) && motionDone(point.b)));
		case 12:
			var coords = cmd.a;
			return A2(
				elm$core$List$all,
				function (_n1) {
					var x = _n1.a;
					var y = _n1.b;
					return motionDone(x) && motionDone(y);
				},
				coords);
		case 13:
			var coords = cmd.a;
			return A2(
				elm$core$List$all,
				function (_n2) {
					var x = _n2.a;
					var y = _n2.b;
					return motionDone(x) && motionDone(y);
				},
				coords);
		case 14:
			var coords = cmd.a;
			return A2(
				elm$core$List$all,
				function (_n3) {
					var x = _n3.a;
					var y = _n3.b;
					return motionDone(x) && motionDone(y);
				},
				coords);
		case 15:
			var coords = cmd.a;
			return A2(
				elm$core$List$all,
				function (_n4) {
					var x = _n4.a;
					var y = _n4.b;
					return motionDone(x) && motionDone(y);
				},
				coords);
		case 16:
			var arc = cmd.a;
			return motionDone(arc.ay) && (motionDone(arc.az) && (motionDone(arc.ar) && (motionDone(arc.as) && motionDone(arc.am))));
		case 17:
			var arc = cmd.a;
			return motionDone(arc.ay) && (motionDone(arc.az) && (motionDone(arc.ar) && (motionDone(arc.as) && motionDone(arc.am))));
		default:
			return true;
	}
};
var elm$core$Maybe$withDefault = F2(
	function (_default, maybe) {
		if (!maybe.$) {
			var value = maybe.a;
			return value;
		} else {
			return _default;
		}
	});
var author$project$Animation$Model$isDone = function (property) {
	var motionDone = function (motion) {
		var runningInterpolation = A2(elm$core$Maybe$withDefault, motion.ab, motion.cI);
		switch (runningInterpolation.$) {
			case 0:
				return (!motion.dz) && _Utils_eq(motion.cZ, motion.df);
			case 1:
				var eased = runningInterpolation.a;
				return (eased.bG === 1) || ((!eased.bG) && _Utils_eq(motion.cZ, motion.df));
			default:
				var speed = runningInterpolation.a;
				return _Utils_eq(motion.cZ, motion.df);
		}
	};
	switch (property.$) {
		case 0:
			return true;
		case 1:
			var m1 = property.b;
			var m2 = property.c;
			var m3 = property.d;
			var m4 = property.e;
			return A2(
				elm$core$List$all,
				motionDone,
				_List_fromArray(
					[m1, m2, m3, m4]));
		case 2:
			var shadow = property.c;
			return A2(
				elm$core$List$all,
				motionDone,
				_List_fromArray(
					[shadow.t, shadow.u, shadow.x, shadow.s, shadow.m, shadow.l, shadow.j, shadow.i]));
		case 3:
			var m1 = property.b;
			return motionDone(m1);
		case 4:
			var m1 = property.b;
			var m2 = property.c;
			return motionDone(m1) && motionDone(m2);
		case 5:
			var m1 = property.b;
			var m2 = property.c;
			var m3 = property.d;
			return A2(
				elm$core$List$all,
				motionDone,
				_List_fromArray(
					[m1, m2, m3]));
		case 6:
			var m1 = property.b;
			var m2 = property.c;
			var m3 = property.d;
			var m4 = property.e;
			return A2(
				elm$core$List$all,
				motionDone,
				_List_fromArray(
					[m1, m2, m3, m4]));
		case 7:
			var m1 = property.b;
			return motionDone(m1);
		case 8:
			var ms = property.a;
			return A2(
				elm$core$List$all,
				function (_n1) {
					var x = _n1.a;
					var y = _n1.b;
					return motionDone(x) && motionDone(y);
				},
				ms);
		default:
			var cmds = property.a;
			return A2(elm$core$List$all, author$project$Animation$Model$isCmdDone, cmds);
	}
};
var elm$core$Basics$abs = function (n) {
	return (n < 0) ? (-n) : n;
};
var elm$core$List$repeatHelp = F3(
	function (result, n, value) {
		repeatHelp:
		while (true) {
			if (n <= 0) {
				return result;
			} else {
				var $temp$result = A2(elm$core$List$cons, value, result),
					$temp$n = n - 1,
					$temp$value = value;
				result = $temp$result;
				n = $temp$n;
				value = $temp$value;
				continue repeatHelp;
			}
		}
	});
var elm$core$List$repeat = F2(
	function (n, value) {
		return A3(elm$core$List$repeatHelp, _List_Nil, n, value);
	});
var author$project$Animation$Model$matchPoints = F2(
	function (points1, points2) {
		var diff = elm$core$List$length(points1) - elm$core$List$length(points2);
		if (diff > 0) {
			var _n0 = elm$core$List$head(
				elm$core$List$reverse(points2));
			if (_n0.$ === 1) {
				return _Utils_Tuple2(points1, points2);
			} else {
				var last2 = _n0.a;
				return _Utils_Tuple2(
					points1,
					_Utils_ap(
						points2,
						A2(
							elm$core$List$repeat,
							elm$core$Basics$abs(diff),
							last2)));
			}
		} else {
			if (diff < 0) {
				var _n1 = elm$core$List$head(
					elm$core$List$reverse(points1));
				if (_n1.$ === 1) {
					return _Utils_Tuple2(points1, points2);
				} else {
					var last1 = _n1.a;
					return _Utils_Tuple2(
						_Utils_ap(
							points1,
							A2(
								elm$core$List$repeat,
								elm$core$Basics$abs(diff),
								last1)),
						points2);
				}
			} else {
				return _Utils_Tuple2(points1, points2);
			}
		}
	});
var author$project$Animation$Model$setPathTarget = F2(
	function (cmd, targetCmd) {
		var setMotionTarget = F2(
			function (motion, targetMotion) {
				var _n27 = motion.ab;
				if (_n27.$ === 1) {
					var ease = _n27.a;
					return _Utils_update(
						motion,
						{
							ab: author$project$Animation$Model$Easing(
								_Utils_update(
									ease,
									{bN: motion.cZ})),
							df: targetMotion.cZ
						});
				} else {
					return _Utils_update(
						motion,
						{df: targetMotion.cZ});
				}
			});
		switch (cmd.$) {
			case 0:
				var m1 = cmd.a;
				var m2 = cmd.b;
				if (!targetCmd.$) {
					var t1 = targetCmd.a;
					var t2 = targetCmd.b;
					return A2(
						author$project$Animation$Model$Move,
						A2(setMotionTarget, m1, t1),
						A2(setMotionTarget, m2, t2));
				} else {
					return cmd;
				}
			case 1:
				var m1 = cmd.a;
				var m2 = cmd.b;
				if (targetCmd.$ === 1) {
					var t1 = targetCmd.a;
					var t2 = targetCmd.b;
					return A2(
						author$project$Animation$Model$MoveTo,
						A2(setMotionTarget, m1, t1),
						A2(setMotionTarget, m2, t2));
				} else {
					return cmd;
				}
			case 2:
				var m1 = cmd.a;
				var m2 = cmd.b;
				if (targetCmd.$ === 2) {
					var t1 = targetCmd.a;
					var t2 = targetCmd.b;
					return A2(
						author$project$Animation$Model$Line,
						A2(setMotionTarget, m1, t1),
						A2(setMotionTarget, m2, t2));
				} else {
					return cmd;
				}
			case 3:
				var m1 = cmd.a;
				var m2 = cmd.b;
				if (targetCmd.$ === 3) {
					var t1 = targetCmd.a;
					var t2 = targetCmd.b;
					return A2(
						author$project$Animation$Model$LineTo,
						A2(setMotionTarget, m1, t1),
						A2(setMotionTarget, m2, t2));
				} else {
					return cmd;
				}
			case 4:
				var m1 = cmd.a;
				if (targetCmd.$ === 4) {
					var t1 = targetCmd.a;
					return author$project$Animation$Model$Horizontal(
						A2(setMotionTarget, m1, t1));
				} else {
					return cmd;
				}
			case 5:
				var m1 = cmd.a;
				if (targetCmd.$ === 5) {
					var t1 = targetCmd.a;
					return author$project$Animation$Model$HorizontalTo(
						A2(setMotionTarget, m1, t1));
				} else {
					return cmd;
				}
			case 6:
				var m1 = cmd.a;
				if (targetCmd.$ === 6) {
					var t1 = targetCmd.a;
					return author$project$Animation$Model$Vertical(
						A2(setMotionTarget, m1, t1));
				} else {
					return cmd;
				}
			case 7:
				var m1 = cmd.a;
				if (targetCmd.$ === 7) {
					var t1 = targetCmd.a;
					return author$project$Animation$Model$VerticalTo(
						A2(setMotionTarget, m1, t1));
				} else {
					return cmd;
				}
			case 8:
				var points = cmd.a;
				if (targetCmd.$ === 8) {
					var targets = targetCmd.a;
					return author$project$Animation$Model$Curve(
						{
							ak: _Utils_Tuple2(
								A2(setMotionTarget, points.ak.a, targets.ak.a),
								A2(setMotionTarget, points.ak.b, targets.ak.b)),
							al: _Utils_Tuple2(
								A2(setMotionTarget, points.al.a, targets.al.a),
								A2(setMotionTarget, points.al.b, targets.al.b)),
							w: _Utils_Tuple2(
								A2(setMotionTarget, points.w.a, targets.w.a),
								A2(setMotionTarget, points.w.b, targets.w.b))
						});
				} else {
					return cmd;
				}
			case 9:
				var points = cmd.a;
				if (targetCmd.$ === 9) {
					var targets = targetCmd.a;
					return author$project$Animation$Model$CurveTo(
						{
							ak: _Utils_Tuple2(
								A2(setMotionTarget, points.ak.a, targets.ak.a),
								A2(setMotionTarget, points.ak.b, targets.ak.b)),
							al: _Utils_Tuple2(
								A2(setMotionTarget, points.al.a, targets.al.a),
								A2(setMotionTarget, points.al.b, targets.al.b)),
							w: _Utils_Tuple2(
								A2(setMotionTarget, points.w.a, targets.w.a),
								A2(setMotionTarget, points.w.b, targets.w.b))
						});
				} else {
					return cmd;
				}
			case 10:
				var points = cmd.a;
				if (targetCmd.$ === 10) {
					var targets = targetCmd.a;
					return author$project$Animation$Model$Quadratic(
						{
							aj: _Utils_Tuple2(
								A2(setMotionTarget, points.aj.a, targets.aj.a),
								A2(setMotionTarget, points.aj.b, targets.aj.b)),
							w: _Utils_Tuple2(
								A2(setMotionTarget, points.w.a, targets.w.a),
								A2(setMotionTarget, points.w.b, targets.w.b))
						});
				} else {
					return cmd;
				}
			case 11:
				var points = cmd.a;
				if (targetCmd.$ === 11) {
					var targets = targetCmd.a;
					return author$project$Animation$Model$QuadraticTo(
						{
							aj: _Utils_Tuple2(
								A2(setMotionTarget, points.aj.a, targets.aj.a),
								A2(setMotionTarget, points.aj.b, targets.aj.b)),
							w: _Utils_Tuple2(
								A2(setMotionTarget, points.w.a, targets.w.a),
								A2(setMotionTarget, points.w.b, targets.w.b))
						});
				} else {
					return cmd;
				}
			case 12:
				var coords = cmd.a;
				if (targetCmd.$ === 12) {
					var targetCoords = targetCmd.a;
					return author$project$Animation$Model$SmoothQuadratic(
						A3(
							elm$core$List$map2,
							F2(
								function (_n14, _n15) {
									var x1 = _n14.a;
									var y1 = _n14.b;
									var x2 = _n15.a;
									var y2 = _n15.b;
									return _Utils_Tuple2(
										A2(setMotionTarget, x1, x2),
										A2(setMotionTarget, y1, y2));
								}),
							coords,
							targetCoords));
				} else {
					return cmd;
				}
			case 13:
				var coords = cmd.a;
				if (targetCmd.$ === 13) {
					var targetCoords = targetCmd.a;
					return author$project$Animation$Model$SmoothQuadraticTo(
						A3(
							elm$core$List$map2,
							F2(
								function (_n17, _n18) {
									var x1 = _n17.a;
									var y1 = _n17.b;
									var x2 = _n18.a;
									var y2 = _n18.b;
									return _Utils_Tuple2(
										A2(setMotionTarget, x1, x2),
										A2(setMotionTarget, y1, y2));
								}),
							coords,
							targetCoords));
				} else {
					return cmd;
				}
			case 14:
				var coords = cmd.a;
				if (targetCmd.$ === 14) {
					var targetCoords = targetCmd.a;
					return author$project$Animation$Model$Smooth(
						A3(
							elm$core$List$map2,
							F2(
								function (_n20, _n21) {
									var x1 = _n20.a;
									var y1 = _n20.b;
									var x2 = _n21.a;
									var y2 = _n21.b;
									return _Utils_Tuple2(
										A2(setMotionTarget, x1, x2),
										A2(setMotionTarget, y1, y2));
								}),
							coords,
							targetCoords));
				} else {
					return cmd;
				}
			case 15:
				var coords = cmd.a;
				if (targetCmd.$ === 15) {
					var targetCoords = targetCmd.a;
					return author$project$Animation$Model$SmoothTo(
						A3(
							elm$core$List$map2,
							F2(
								function (_n23, _n24) {
									var x1 = _n23.a;
									var y1 = _n23.b;
									var x2 = _n24.a;
									var y2 = _n24.b;
									return _Utils_Tuple2(
										A2(setMotionTarget, x1, x2),
										A2(setMotionTarget, y1, y2));
								}),
							coords,
							targetCoords));
				} else {
					return cmd;
				}
			case 16:
				var arc = cmd.a;
				if (targetCmd.$ === 16) {
					var target = targetCmd.a;
					return author$project$Animation$Model$ClockwiseArc(
						function () {
							var y = arc.az;
							var x = arc.ay;
							var startAngle = arc.as;
							var radius = arc.ar;
							var endAngle = arc.am;
							return _Utils_update(
								arc,
								{
									am: A2(setMotionTarget, endAngle, target.am),
									ar: A2(setMotionTarget, radius, target.ar),
									as: A2(setMotionTarget, startAngle, target.as),
									ay: A2(setMotionTarget, x, target.ay),
									az: A2(setMotionTarget, y, target.az)
								});
						}());
				} else {
					return cmd;
				}
			case 17:
				var arc = cmd.a;
				if (targetCmd.$ === 17) {
					var target = targetCmd.a;
					return author$project$Animation$Model$AntiClockwiseArc(
						function () {
							var y = arc.az;
							var x = arc.ay;
							var startAngle = arc.as;
							var radius = arc.ar;
							var endAngle = arc.am;
							return _Utils_update(
								arc,
								{
									am: A2(setMotionTarget, endAngle, target.am),
									ar: A2(setMotionTarget, radius, target.ar),
									as: A2(setMotionTarget, startAngle, target.as),
									ay: A2(setMotionTarget, x, target.ay),
									az: A2(setMotionTarget, y, target.az)
								});
						}());
				} else {
					return cmd;
				}
			default:
				return author$project$Animation$Model$Close;
		}
	});
var author$project$Animation$Model$setTarget = F3(
	function (overrideInterpolation, current, newTarget) {
		var setMotionTarget = F2(
			function (motion, targetMotion) {
				var newMotion = overrideInterpolation ? _Utils_update(
					motion,
					{
						cI: elm$core$Maybe$Just(targetMotion.ab)
					}) : motion;
				var _n13 = newMotion.cI;
				if (_n13.$ === 1) {
					var _n14 = newMotion.ab;
					if (_n14.$ === 1) {
						var ease = _n14.a;
						return _Utils_update(
							newMotion,
							{
								ab: author$project$Animation$Model$Easing(
									_Utils_update(
										ease,
										{bG: 0, bN: motion.cZ})),
								df: targetMotion.cZ
							});
					} else {
						return _Utils_update(
							newMotion,
							{df: targetMotion.cZ});
					}
				} else {
					var override = _n13.a;
					if (override.$ === 1) {
						var ease = override.a;
						return _Utils_update(
							newMotion,
							{
								cI: elm$core$Maybe$Just(
									author$project$Animation$Model$Easing(
										_Utils_update(
											ease,
											{bG: 0, bN: motion.cZ}))),
								df: targetMotion.cZ
							});
					} else {
						return _Utils_update(
							newMotion,
							{df: targetMotion.cZ});
					}
				}
			});
		switch (current.$) {
			case 0:
				var name = current.a;
				var value = current.b;
				return A2(author$project$Animation$Model$ExactProperty, name, value);
			case 1:
				var name = current.a;
				var m1 = current.b;
				var m2 = current.c;
				var m3 = current.d;
				var m4 = current.e;
				if (newTarget.$ === 1) {
					var t1 = newTarget.b;
					var t2 = newTarget.c;
					var t3 = newTarget.d;
					var t4 = newTarget.e;
					return A5(
						author$project$Animation$Model$ColorProperty,
						name,
						A2(setMotionTarget, m1, t1),
						A2(setMotionTarget, m2, t2),
						A2(setMotionTarget, m3, t3),
						A2(setMotionTarget, m4, t4));
				} else {
					return current;
				}
			case 2:
				var name = current.a;
				var inset = current.b;
				var shadow = current.c;
				if (newTarget.$ === 2) {
					var targetShadow = newTarget.c;
					return A3(
						author$project$Animation$Model$ShadowProperty,
						name,
						inset,
						{
							i: A2(setMotionTarget, shadow.i, targetShadow.i),
							j: A2(setMotionTarget, shadow.j, targetShadow.j),
							s: A2(setMotionTarget, shadow.s, targetShadow.s),
							l: A2(setMotionTarget, shadow.l, targetShadow.l),
							t: A2(setMotionTarget, shadow.t, targetShadow.t),
							u: A2(setMotionTarget, shadow.u, targetShadow.u),
							m: A2(setMotionTarget, shadow.m, targetShadow.m),
							x: A2(setMotionTarget, shadow.x, targetShadow.x)
						});
				} else {
					return current;
				}
			case 3:
				var name = current.a;
				var m1 = current.b;
				if (newTarget.$ === 3) {
					var t1 = newTarget.b;
					return A2(
						author$project$Animation$Model$Property,
						name,
						A2(setMotionTarget, m1, t1));
				} else {
					return current;
				}
			case 4:
				var name = current.a;
				var m1 = current.b;
				var m2 = current.c;
				if (newTarget.$ === 4) {
					var t1 = newTarget.b;
					var t2 = newTarget.c;
					return A3(
						author$project$Animation$Model$Property2,
						name,
						A2(setMotionTarget, m1, t1),
						A2(setMotionTarget, m2, t2));
				} else {
					return current;
				}
			case 5:
				var name = current.a;
				var m1 = current.b;
				var m2 = current.c;
				var m3 = current.d;
				if (newTarget.$ === 5) {
					var t1 = newTarget.b;
					var t2 = newTarget.c;
					var t3 = newTarget.d;
					return A4(
						author$project$Animation$Model$Property3,
						name,
						A2(setMotionTarget, m1, t1),
						A2(setMotionTarget, m2, t2),
						A2(setMotionTarget, m3, t3));
				} else {
					return current;
				}
			case 6:
				var name = current.a;
				var m1 = current.b;
				var m2 = current.c;
				var m3 = current.d;
				var m4 = current.e;
				if (newTarget.$ === 6) {
					var t1 = newTarget.b;
					var t2 = newTarget.c;
					var t3 = newTarget.d;
					var t4 = newTarget.e;
					return A5(
						author$project$Animation$Model$Property4,
						name,
						A2(setMotionTarget, m1, t1),
						A2(setMotionTarget, m2, t2),
						A2(setMotionTarget, m3, t3),
						A2(setMotionTarget, m4, t4));
				} else {
					return current;
				}
			case 7:
				var name = current.a;
				var m1 = current.b;
				if (newTarget.$ === 7) {
					var t1 = newTarget.b;
					return A2(
						author$project$Animation$Model$AngleProperty,
						name,
						A2(setMotionTarget, m1, t1));
				} else {
					return current;
				}
			case 8:
				var currentPts = current.a;
				if (newTarget.$ === 8) {
					var targetPts = newTarget.a;
					var _n9 = A2(author$project$Animation$Model$matchPoints, currentPts, targetPts);
					var m1s = _n9.a;
					var m2s = _n9.b;
					return author$project$Animation$Model$Points(
						A3(
							elm$core$List$map2,
							F2(
								function (_n10, _n11) {
									var x1 = _n10.a;
									var y1 = _n10.b;
									var x2 = _n11.a;
									var y2 = _n11.b;
									return _Utils_Tuple2(
										A2(setMotionTarget, x1, x2),
										A2(setMotionTarget, y1, y2));
								}),
							m1s,
							m2s));
				} else {
					return current;
				}
			default:
				var cmds = current.a;
				if (newTarget.$ === 9) {
					var targets = newTarget.a;
					return author$project$Animation$Model$Path(
						A3(elm$core$List$map2, author$project$Animation$Model$setPathTarget, cmds, targets));
				} else {
					return current;
				}
		}
	});
var elm$core$List$partition = F2(
	function (pred, list) {
		var step = F2(
			function (x, _n0) {
				var trues = _n0.a;
				var falses = _n0.b;
				return pred(x) ? _Utils_Tuple2(
					A2(elm$core$List$cons, x, trues),
					falses) : _Utils_Tuple2(
					trues,
					A2(elm$core$List$cons, x, falses));
			});
		return A3(
			elm$core$List$foldr,
			step,
			_Utils_Tuple2(_List_Nil, _List_Nil),
			list);
	});
var author$project$Animation$Model$zipPropertiesGreedy = F2(
	function (initialProps, newTargetProps) {
		var propertyMatch = F2(
			function (prop1, prop2) {
				return _Utils_eq(
					author$project$Animation$Model$propertyName(prop1),
					author$project$Animation$Model$propertyName(prop2));
			});
		var _n0 = A3(
			elm$core$List$foldl,
			F2(
				function (_n1, _n2) {
					var stackA = _n2.a;
					var stackB = _n2.b;
					var result = _n2.c;
					var _n3 = elm$core$List$head(stackA);
					if (_n3.$ === 1) {
						return _Utils_Tuple3(stackA, stackB, result);
					} else {
						var a = _n3.a;
						var _n4 = A2(
							elm$core$List$partition,
							propertyMatch(a),
							stackB);
						var matchingBs = _n4.a;
						var nonMatchingBs = _n4.b;
						return _Utils_Tuple3(
							A2(elm$core$List$drop, 1, stackA),
							function () {
								if (!matchingBs.b) {
									return nonMatchingBs;
								} else {
									var b = matchingBs.a;
									var remainingBs = matchingBs.b;
									return _Utils_ap(remainingBs, nonMatchingBs);
								}
							}(),
							A2(
								elm$core$List$cons,
								_Utils_Tuple2(
									a,
									elm$core$List$head(matchingBs)),
								result));
					}
				}),
			_Utils_Tuple3(initialProps, newTargetProps, _List_Nil),
			A2(
				elm$core$List$repeat,
				elm$core$List$length(initialProps),
				0));
		var warnings = _n0.b;
		var props = _n0.c;
		var _n6 = warnings;
		return elm$core$List$reverse(props);
	});
var author$project$Animation$Model$startTowards = F3(
	function (overrideInterpolation, current, target) {
		return A2(
			elm$core$List$filterMap,
			function (propPair) {
				if (!propPair.b.$) {
					var cur = propPair.a;
					var to = propPair.b.a;
					return elm$core$Maybe$Just(
						A3(author$project$Animation$Model$setTarget, overrideInterpolation, cur, to));
				} else {
					var prop = propPair.a;
					var _n1 = propPair.b;
					return elm$core$Maybe$Just(prop);
				}
			},
			A2(author$project$Animation$Model$zipPropertiesGreedy, current, target));
	});
var author$project$Animation$Model$tolerance = 1.0e-2;
var author$project$Animation$Model$vTolerance = 0.1;
var elm$core$Basics$ge = _Utils_ge;
var elm$core$Basics$truncate = _Basics_truncate;
var author$project$Animation$Model$stepInterpolation = F2(
	function (posix, motion) {
		var interpolationToUse = A2(elm$core$Maybe$withDefault, motion.ab, motion.cI);
		var dtms = elm$time$Time$posixToMillis(posix);
		switch (interpolationToUse.$) {
			case 2:
				var perSecond = interpolationToUse.a.bB;
				var _n1 = function () {
					if (_Utils_cmp(motion.cZ, motion.df) < 0) {
						var _new = motion.cZ + (perSecond * (dtms / 1000));
						return _Utils_Tuple2(
							_new,
							_Utils_cmp(_new, motion.df) > -1);
					} else {
						var _new = motion.cZ - (perSecond * (dtms / 1000));
						return _Utils_Tuple2(
							_new,
							_Utils_cmp(_new, motion.df) < 1);
					}
				}();
				var newPos = _n1.a;
				var finished = _n1.b;
				return finished ? _Utils_update(
					motion,
					{cZ: motion.df, dz: 0.0}) : _Utils_update(
					motion,
					{cZ: newPos, dz: perSecond * 1000});
			case 0:
				var stiffness = interpolationToUse.a.bO;
				var damping = interpolationToUse.a.bi;
				var fspring = stiffness * (motion.df - motion.cZ);
				var fdamper = ((-1) * damping) * motion.dz;
				var dt = dtms / 1000;
				var a = fspring + fdamper;
				var newVelocity = motion.dz + (a * dt);
				var newPos = motion.cZ + (newVelocity * dt);
				var dx = elm$core$Basics$abs(motion.df - newPos);
				return ((_Utils_cmp(dx, author$project$Animation$Model$tolerance) < 0) && (_Utils_cmp(
					elm$core$Basics$abs(newVelocity),
					author$project$Animation$Model$vTolerance) < 0)) ? _Utils_update(
					motion,
					{cZ: motion.df, dz: 0.0}) : _Utils_update(
					motion,
					{cZ: newPos, dz: newVelocity});
			default:
				var progress = interpolationToUse.a.bG;
				var duration = interpolationToUse.a.aV;
				var ease = interpolationToUse.a.aW;
				var start = interpolationToUse.a.bN;
				var durationMs = elm$time$Time$posixToMillis(duration);
				var newProgress = (((dtms / durationMs) + progress) < 1) ? ((dtms / durationMs) + progress) : 1;
				var eased = ease(newProgress);
				var distance = motion.df - start;
				var newPos = ((((eased * distance) + start) * 10000) | 0) / 10000;
				var newVelocity = (newProgress === 1) ? 0 : ((newPos - motion.cZ) / dtms);
				var _n2 = motion.cI;
				if (_n2.$ === 1) {
					return _Utils_update(
						motion,
						{
							ab: author$project$Animation$Model$Easing(
								{aV: duration, aW: ease, bG: newProgress, bN: start}),
							cZ: newPos,
							dz: newVelocity
						});
				} else {
					var override = _n2.a;
					return _Utils_update(
						motion,
						{
							cI: elm$core$Maybe$Just(
								author$project$Animation$Model$Easing(
									{aV: duration, aW: ease, bG: newProgress, bN: start})),
							cZ: newPos,
							dz: newVelocity
						});
				}
		}
	});
var author$project$Animation$Model$stepPath = F2(
	function (dt, cmd) {
		var stepCoords = function (coords) {
			return A2(
				elm$core$List$map,
				function (_n1) {
					var x = _n1.a;
					var y = _n1.b;
					return _Utils_Tuple2(
						A2(author$project$Animation$Model$stepInterpolation, dt, x),
						A2(author$project$Animation$Model$stepInterpolation, dt, y));
				},
				coords);
		};
		switch (cmd.$) {
			case 0:
				var m1 = cmd.a;
				var m2 = cmd.b;
				return A2(
					author$project$Animation$Model$Move,
					A2(author$project$Animation$Model$stepInterpolation, dt, m1),
					A2(author$project$Animation$Model$stepInterpolation, dt, m2));
			case 1:
				var m1 = cmd.a;
				var m2 = cmd.b;
				return A2(
					author$project$Animation$Model$MoveTo,
					A2(author$project$Animation$Model$stepInterpolation, dt, m1),
					A2(author$project$Animation$Model$stepInterpolation, dt, m2));
			case 2:
				var m1 = cmd.a;
				var m2 = cmd.b;
				return A2(
					author$project$Animation$Model$Line,
					A2(author$project$Animation$Model$stepInterpolation, dt, m1),
					A2(author$project$Animation$Model$stepInterpolation, dt, m2));
			case 3:
				var m1 = cmd.a;
				var m2 = cmd.b;
				return A2(
					author$project$Animation$Model$LineTo,
					A2(author$project$Animation$Model$stepInterpolation, dt, m1),
					A2(author$project$Animation$Model$stepInterpolation, dt, m2));
			case 4:
				var motion = cmd.a;
				return author$project$Animation$Model$Horizontal(
					A2(author$project$Animation$Model$stepInterpolation, dt, motion));
			case 5:
				var motion = cmd.a;
				return author$project$Animation$Model$HorizontalTo(
					A2(author$project$Animation$Model$stepInterpolation, dt, motion));
			case 6:
				var motion = cmd.a;
				return author$project$Animation$Model$Vertical(
					A2(author$project$Animation$Model$stepInterpolation, dt, motion));
			case 7:
				var motion = cmd.a;
				return author$project$Animation$Model$VerticalTo(
					A2(author$project$Animation$Model$stepInterpolation, dt, motion));
			case 8:
				var control1 = cmd.a.ak;
				var control2 = cmd.a.al;
				var point = cmd.a.w;
				return author$project$Animation$Model$Curve(
					{
						ak: _Utils_Tuple2(
							A2(author$project$Animation$Model$stepInterpolation, dt, control1.a),
							A2(author$project$Animation$Model$stepInterpolation, dt, control1.b)),
						al: _Utils_Tuple2(
							A2(author$project$Animation$Model$stepInterpolation, dt, control2.a),
							A2(author$project$Animation$Model$stepInterpolation, dt, control2.b)),
						w: _Utils_Tuple2(
							A2(author$project$Animation$Model$stepInterpolation, dt, point.a),
							A2(author$project$Animation$Model$stepInterpolation, dt, point.b))
					});
			case 9:
				var control1 = cmd.a.ak;
				var control2 = cmd.a.al;
				var point = cmd.a.w;
				return author$project$Animation$Model$CurveTo(
					{
						ak: _Utils_Tuple2(
							A2(author$project$Animation$Model$stepInterpolation, dt, control1.a),
							A2(author$project$Animation$Model$stepInterpolation, dt, control1.b)),
						al: _Utils_Tuple2(
							A2(author$project$Animation$Model$stepInterpolation, dt, control2.a),
							A2(author$project$Animation$Model$stepInterpolation, dt, control2.b)),
						w: _Utils_Tuple2(
							A2(author$project$Animation$Model$stepInterpolation, dt, point.a),
							A2(author$project$Animation$Model$stepInterpolation, dt, point.b))
					});
			case 10:
				var control = cmd.a.aj;
				var point = cmd.a.w;
				return author$project$Animation$Model$Quadratic(
					{
						aj: _Utils_Tuple2(
							A2(author$project$Animation$Model$stepInterpolation, dt, control.a),
							A2(author$project$Animation$Model$stepInterpolation, dt, control.b)),
						w: _Utils_Tuple2(
							A2(author$project$Animation$Model$stepInterpolation, dt, point.a),
							A2(author$project$Animation$Model$stepInterpolation, dt, point.b))
					});
			case 11:
				var control = cmd.a.aj;
				var point = cmd.a.w;
				return author$project$Animation$Model$QuadraticTo(
					{
						aj: _Utils_Tuple2(
							A2(author$project$Animation$Model$stepInterpolation, dt, control.a),
							A2(author$project$Animation$Model$stepInterpolation, dt, control.b)),
						w: _Utils_Tuple2(
							A2(author$project$Animation$Model$stepInterpolation, dt, point.a),
							A2(author$project$Animation$Model$stepInterpolation, dt, point.b))
					});
			case 12:
				var coords = cmd.a;
				return author$project$Animation$Model$SmoothQuadratic(
					stepCoords(coords));
			case 13:
				var coords = cmd.a;
				return author$project$Animation$Model$SmoothQuadraticTo(
					stepCoords(coords));
			case 14:
				var coords = cmd.a;
				return author$project$Animation$Model$Smooth(
					stepCoords(coords));
			case 15:
				var coords = cmd.a;
				return author$project$Animation$Model$SmoothTo(
					stepCoords(coords));
			case 16:
				var arc = cmd.a;
				return author$project$Animation$Model$ClockwiseArc(
					_Utils_update(
						arc,
						{
							am: A2(author$project$Animation$Model$stepInterpolation, dt, arc.am),
							ar: A2(author$project$Animation$Model$stepInterpolation, dt, arc.ar),
							as: A2(author$project$Animation$Model$stepInterpolation, dt, arc.as),
							ay: A2(author$project$Animation$Model$stepInterpolation, dt, arc.ay),
							az: A2(author$project$Animation$Model$stepInterpolation, dt, arc.az)
						}));
			case 17:
				var arc = cmd.a;
				return author$project$Animation$Model$AntiClockwiseArc(
					_Utils_update(
						arc,
						{
							am: A2(author$project$Animation$Model$stepInterpolation, dt, arc.am),
							ar: A2(author$project$Animation$Model$stepInterpolation, dt, arc.ar),
							as: A2(author$project$Animation$Model$stepInterpolation, dt, arc.as),
							ay: A2(author$project$Animation$Model$stepInterpolation, dt, arc.ay),
							az: A2(author$project$Animation$Model$stepInterpolation, dt, arc.az)
						}));
			default:
				return author$project$Animation$Model$Close;
		}
	});
var author$project$Animation$Model$step = F2(
	function (dt, props) {
		var stepProp = function (property) {
			switch (property.$) {
				case 0:
					var name = property.a;
					var value = property.b;
					return A2(author$project$Animation$Model$ExactProperty, name, value);
				case 3:
					var name = property.a;
					var motion = property.b;
					return A2(
						author$project$Animation$Model$Property,
						name,
						A2(author$project$Animation$Model$stepInterpolation, dt, motion));
				case 4:
					var name = property.a;
					var motion1 = property.b;
					var motion2 = property.c;
					return A3(
						author$project$Animation$Model$Property2,
						name,
						A2(author$project$Animation$Model$stepInterpolation, dt, motion1),
						A2(author$project$Animation$Model$stepInterpolation, dt, motion2));
				case 5:
					var name = property.a;
					var motion1 = property.b;
					var motion2 = property.c;
					var motion3 = property.d;
					return A4(
						author$project$Animation$Model$Property3,
						name,
						A2(author$project$Animation$Model$stepInterpolation, dt, motion1),
						A2(author$project$Animation$Model$stepInterpolation, dt, motion2),
						A2(author$project$Animation$Model$stepInterpolation, dt, motion3));
				case 6:
					var name = property.a;
					var motion1 = property.b;
					var motion2 = property.c;
					var motion3 = property.d;
					var motion4 = property.e;
					return A5(
						author$project$Animation$Model$Property4,
						name,
						A2(author$project$Animation$Model$stepInterpolation, dt, motion1),
						A2(author$project$Animation$Model$stepInterpolation, dt, motion2),
						A2(author$project$Animation$Model$stepInterpolation, dt, motion3),
						A2(author$project$Animation$Model$stepInterpolation, dt, motion4));
				case 7:
					var name = property.a;
					var motion = property.b;
					return A2(
						author$project$Animation$Model$AngleProperty,
						name,
						A2(author$project$Animation$Model$stepInterpolation, dt, motion));
				case 1:
					var name = property.a;
					var red = property.b;
					var green = property.c;
					var blue = property.d;
					var alpha = property.e;
					return A5(
						author$project$Animation$Model$ColorProperty,
						name,
						A2(author$project$Animation$Model$stepInterpolation, dt, red),
						A2(author$project$Animation$Model$stepInterpolation, dt, green),
						A2(author$project$Animation$Model$stepInterpolation, dt, blue),
						A2(author$project$Animation$Model$stepInterpolation, dt, alpha));
				case 2:
					var name = property.a;
					var inset = property.b;
					var shadow = property.c;
					return A3(
						author$project$Animation$Model$ShadowProperty,
						name,
						inset,
						{
							i: A2(author$project$Animation$Model$stepInterpolation, dt, shadow.i),
							j: A2(author$project$Animation$Model$stepInterpolation, dt, shadow.j),
							s: A2(author$project$Animation$Model$stepInterpolation, dt, shadow.s),
							l: A2(author$project$Animation$Model$stepInterpolation, dt, shadow.l),
							t: A2(author$project$Animation$Model$stepInterpolation, dt, shadow.t),
							u: A2(author$project$Animation$Model$stepInterpolation, dt, shadow.u),
							m: A2(author$project$Animation$Model$stepInterpolation, dt, shadow.m),
							x: A2(author$project$Animation$Model$stepInterpolation, dt, shadow.x)
						});
				case 8:
					var points = property.a;
					return author$project$Animation$Model$Points(
						A2(
							elm$core$List$map,
							function (_n1) {
								var x = _n1.a;
								var y = _n1.b;
								return _Utils_Tuple2(
									A2(author$project$Animation$Model$stepInterpolation, dt, x),
									A2(author$project$Animation$Model$stepInterpolation, dt, y));
							},
							points));
				default:
					var cmds = property.a;
					return author$project$Animation$Model$Path(
						A2(
							elm$core$List$map,
							author$project$Animation$Model$stepPath(dt),
							cmds));
			}
		};
		return A2(elm$core$List$map, stepProp, props);
	});
var author$project$Animation$Model$alreadyThere = F2(
	function (current, target) {
		return A2(
			elm$core$List$all,
			author$project$Animation$Model$isDone,
			A2(
				author$project$Animation$Model$step,
				elm$time$Time$millisToPosix(0),
				A3(author$project$Animation$Model$startTowards, false, current, target)));
	});
var author$project$Animation$Model$replaceProps = F2(
	function (props, replacements) {
		var replacementNames = A2(elm$core$List$map, author$project$Animation$Model$propertyName, replacements);
		var removed = A2(
			elm$core$List$filter,
			function (prop) {
				return !A2(
					elm$core$List$member,
					author$project$Animation$Model$propertyName(prop),
					replacementNames);
			},
			props);
		return _Utils_ap(removed, replacements);
	});
var author$project$Animation$Model$resolveSteps = F3(
	function (currentStyle, steps, dt) {
		resolveSteps:
		while (true) {
			var _n0 = elm$core$List$head(steps);
			if (_n0.$ === 1) {
				return _Utils_Tuple3(currentStyle, _List_Nil, _List_Nil);
			} else {
				var currentStep = _n0.a;
				switch (currentStep.$) {
					case 4:
						var n = currentStep.a;
						if (elm$time$Time$posixToMillis(n) <= 0) {
							var $temp$currentStyle = currentStyle,
								$temp$steps = A2(elm$core$List$drop, 1, steps),
								$temp$dt = dt;
							currentStyle = $temp$currentStyle;
							steps = $temp$steps;
							dt = $temp$dt;
							continue resolveSteps;
						} else {
							return _Utils_Tuple3(
								currentStyle,
								_List_Nil,
								A2(
									elm$core$List$cons,
									author$project$Animation$Model$Wait(
										elm$time$Time$millisToPosix(
											elm$time$Time$posixToMillis(n) - elm$time$Time$posixToMillis(dt))),
									A2(elm$core$List$drop, 1, steps)));
						}
					case 5:
						var msg = currentStep.a;
						var _n2 = A3(
							author$project$Animation$Model$resolveSteps,
							currentStyle,
							A2(elm$core$List$drop, 1, steps),
							dt);
						var newStyle = _n2.a;
						var msgs = _n2.b;
						var remainingSteps = _n2.c;
						return _Utils_Tuple3(
							newStyle,
							A2(elm$core$List$cons, msg, msgs),
							remainingSteps);
					case 1:
						var target = currentStep.a;
						if (A2(author$project$Animation$Model$alreadyThere, currentStyle, target)) {
							return _Utils_Tuple3(
								currentStyle,
								_List_Nil,
								A2(elm$core$List$drop, 1, steps));
						} else {
							var $temp$currentStyle = A3(author$project$Animation$Model$startTowards, false, currentStyle, target),
								$temp$steps = A2(
								elm$core$List$cons,
								author$project$Animation$Model$Step,
								A2(elm$core$List$drop, 1, steps)),
								$temp$dt = dt;
							currentStyle = $temp$currentStyle;
							steps = $temp$steps;
							dt = $temp$dt;
							continue resolveSteps;
						}
					case 2:
						var target = currentStep.a;
						if (A2(author$project$Animation$Model$alreadyThere, currentStyle, target)) {
							return _Utils_Tuple3(
								currentStyle,
								_List_Nil,
								A2(elm$core$List$drop, 1, steps));
						} else {
							var $temp$currentStyle = A3(author$project$Animation$Model$startTowards, true, currentStyle, target),
								$temp$steps = A2(
								elm$core$List$cons,
								author$project$Animation$Model$Step,
								A2(elm$core$List$drop, 1, steps)),
								$temp$dt = dt;
							currentStyle = $temp$currentStyle;
							steps = $temp$steps;
							dt = $temp$dt;
							continue resolveSteps;
						}
					case 3:
						var props = currentStep.a;
						var $temp$currentStyle = A2(author$project$Animation$Model$replaceProps, currentStyle, props),
							$temp$steps = A2(elm$core$List$drop, 1, steps),
							$temp$dt = dt;
						currentStyle = $temp$currentStyle;
						steps = $temp$steps;
						dt = $temp$dt;
						continue resolveSteps;
					case 0:
						var stepped = A2(author$project$Animation$Model$step, dt, currentStyle);
						return A2(elm$core$List$all, author$project$Animation$Model$isDone, stepped) ? _Utils_Tuple3(
							A2(
								elm$core$List$map,
								author$project$Animation$Model$mapToMotion(
									function (m) {
										return _Utils_update(
											m,
											{cI: elm$core$Maybe$Nothing});
									}),
								stepped),
							_List_Nil,
							A2(elm$core$List$drop, 1, steps)) : _Utils_Tuple3(stepped, _List_Nil, steps);
					case 7:
						var substeps = currentStep.a;
						var $temp$currentStyle = currentStyle,
							$temp$steps = _Utils_ap(
							substeps,
							_List_fromArray(
								[
									author$project$Animation$Model$Loop(substeps)
								])),
							$temp$dt = dt;
						currentStyle = $temp$currentStyle;
						steps = $temp$steps;
						dt = $temp$dt;
						continue resolveSteps;
					default:
						var n = currentStep.a;
						var substeps = currentStep.b;
						if (n <= 0) {
							var $temp$currentStyle = currentStyle,
								$temp$steps = A2(elm$core$List$drop, 1, steps),
								$temp$dt = dt;
							currentStyle = $temp$currentStyle;
							steps = $temp$steps;
							dt = $temp$dt;
							continue resolveSteps;
						} else {
							var $temp$currentStyle = currentStyle,
								$temp$steps = _Utils_ap(
								substeps,
								_Utils_ap(
									_List_fromArray(
										[
											A2(author$project$Animation$Model$Repeat, n - 1, substeps)
										]),
									A2(elm$core$List$drop, 1, steps))),
								$temp$dt = dt;
							currentStyle = $temp$currentStyle;
							steps = $temp$steps;
							dt = $temp$dt;
							continue resolveSteps;
						}
				}
			}
		}
	});
var elm$core$Basics$neq = _Utils_notEqual;
var elm$core$Platform$Cmd$batch = _Platform_batch;
var author$project$Animation$Model$updateAnimation = F2(
	function (_n0, _n1) {
		var now = _n0;
		var model = _n1;
		var timing = A2(author$project$Animation$Model$refreshTiming, now, model.bS);
		var _n2 = A2(
			elm$core$List$partition,
			function (_n4) {
				var wait = _n4.a;
				var mySteps = _n4.b;
				return elm$time$Time$posixToMillis(wait) <= 0;
			},
			A2(
				elm$core$List$map,
				function (_n3) {
					var wait = _n3.a;
					var mySteps = _n3.b;
					return _Utils_Tuple2(
						elm$time$Time$millisToPosix(
							elm$time$Time$posixToMillis(wait) - elm$time$Time$posixToMillis(timing.cq)),
						mySteps);
				},
				model.aZ));
		var readyInterruption = _n2.a;
		var queuedInterruptions = _n2.b;
		var _n5 = function () {
			var _n6 = elm$core$List$head(readyInterruption);
			if (!_n6.$) {
				var _n7 = _n6.a;
				var wait = _n7.a;
				var interrupt = _n7.b;
				return _Utils_Tuple2(
					interrupt,
					A2(
						elm$core$List$map,
						author$project$Animation$Model$mapToMotion(
							function (m) {
								return _Utils_update(
									m,
									{cI: elm$core$Maybe$Nothing});
							}),
						model.bP));
			} else {
				return _Utils_Tuple2(model.a3, model.bP);
			}
		}();
		var steps = _n5.a;
		var style = _n5.b;
		var _n8 = A3(author$project$Animation$Model$resolveSteps, style, steps, timing.cq);
		var revisedStyle = _n8.a;
		var sentMessages = _n8.b;
		var revisedSteps = _n8.c;
		return _Utils_Tuple2(
			_Utils_update(
				model,
				{
					aZ: queuedInterruptions,
					aM: elm$core$List$length(revisedSteps) || elm$core$List$length(queuedInterruptions),
					a3: revisedSteps,
					bP: revisedStyle,
					bS: timing
				}),
			elm$core$Platform$Cmd$batch(
				A2(
					elm$core$List$map,
					function (m) {
						return A2(
							elm$core$Task$perform,
							elm$core$Basics$identity,
							elm$core$Task$succeed(m));
					},
					sentMessages)));
	});
var author$project$Animation$update = F2(
	function (tick, animation) {
		return A2(author$project$Animation$Model$updateAnimation, tick, animation).a;
	});
var elm$browser$Browser$Navigation$load = _Browser_load;
var elm$browser$Browser$Navigation$pushUrl = _Browser_pushUrl;
var elm$core$Platform$Cmd$none = elm$core$Platform$Cmd$batch(_List_Nil);
var elm$core$String$fromInt = _String_fromNumber;
var elm$url$Url$addPort = F2(
	function (maybePort, starter) {
		if (maybePort.$ === 1) {
			return starter;
		} else {
			var port_ = maybePort.a;
			return starter + (':' + elm$core$String$fromInt(port_));
		}
	});
var elm$url$Url$addPrefixed = F3(
	function (prefix, maybeSegment, starter) {
		if (maybeSegment.$ === 1) {
			return starter;
		} else {
			var segment = maybeSegment.a;
			return _Utils_ap(
				starter,
				_Utils_ap(prefix, segment));
		}
	});
var elm$url$Url$toString = function (url) {
	var http = function () {
		var _n0 = url.bH;
		if (!_n0) {
			return 'http://';
		} else {
			return 'https://';
		}
	}();
	return A3(
		elm$url$Url$addPrefixed,
		'#',
		url.bm,
		A3(
			elm$url$Url$addPrefixed,
			'?',
			url.bI,
			_Utils_ap(
				A2(
					elm$url$Url$addPort,
					url.bD,
					_Utils_ap(http, url.bq)),
				url.bA)));
};
var author$project$Main$update = F2(
	function (action, model) {
		switch (action.$) {
			case 0:
				var time = action.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							M: A2(
								elm$core$List$map,
								author$project$Animation$update(time),
								model.M)
						}),
					elm$core$Platform$Cmd$none);
			case 1:
				var viewport = action.a.dB;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							_: {
								aU: mdgriffith$stylish_elephants$Element$classifyDevice(
									{
										G: elm$core$Basics$round(viewport.G),
										D: elm$core$Basics$round(viewport.D)
									}),
								G: viewport.G,
								D: viewport.D
							}
						}),
					elm$core$Platform$Cmd$none);
			case 2:
				var width = action.a;
				var height = action.b;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							_: {
								aU: mdgriffith$stylish_elephants$Element$classifyDevice(
									{G: height, D: width}),
								G: height,
								D: width
							}
						}),
					elm$core$Platform$Cmd$none);
			case 3:
				var url = action.a;
				var newPage = function () {
					var _n1 = url.bm;
					if (_n1.$ === 1) {
						return 0;
					} else {
						var fragment = _n1.a;
						if (fragment === 'why-elm') {
							return 1;
						} else {
							return 0;
						}
					}
				}();
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{aq: newPage}),
					elm$core$Platform$Cmd$none);
			default:
				var urlRequest = action.a;
				if (!urlRequest.$) {
					var url = urlRequest.a;
					return _Utils_Tuple2(
						model,
						A2(
							elm$browser$Browser$Navigation$pushUrl,
							model.a_,
							elm$url$Url$toString(url)));
				} else {
					var href = urlRequest.a;
					return _Utils_Tuple2(
						model,
						elm$browser$Browser$Navigation$load(href));
				}
		}
	});
var author$project$Animation$Render$iePrefix = '-ms-';
var author$project$Animation$Render$webkitPrefix = '-webkit-';
var author$project$Animation$Render$prefix = function (stylePair) {
	var propValue = stylePair.b;
	var propName = stylePair.a;
	switch (propName) {
		case 'transform':
			return _List_fromArray(
				[
					stylePair,
					_Utils_Tuple2(
					_Utils_ap(author$project$Animation$Render$iePrefix, propName),
					propValue),
					_Utils_Tuple2(
					_Utils_ap(author$project$Animation$Render$webkitPrefix, propName),
					propValue)
				]);
		case 'transform-origin':
			return _List_fromArray(
				[
					stylePair,
					_Utils_Tuple2(
					_Utils_ap(author$project$Animation$Render$iePrefix, propName),
					propValue),
					_Utils_Tuple2(
					_Utils_ap(author$project$Animation$Render$webkitPrefix, propName),
					propValue)
				]);
		case 'filter':
			return _List_fromArray(
				[
					stylePair,
					_Utils_Tuple2(
					_Utils_ap(author$project$Animation$Render$iePrefix, propName),
					propValue),
					_Utils_Tuple2(
					_Utils_ap(author$project$Animation$Render$webkitPrefix, propName),
					propValue)
				]);
		default:
			return _List_fromArray(
				[stylePair]);
	}
};
var elm$core$Basics$cos = _Basics_cos;
var elm$core$Basics$degrees = function (angleInDegrees) {
	return (angleInDegrees * elm$core$Basics$pi) / 180;
};
var elm$core$Basics$sin = _Basics_sin;
var elm$core$String$fromFloat = _String_fromNumber;
var elm$core$String$join = F2(
	function (sep, chunks) {
		return A2(
			_String_join,
			sep,
			_List_toArray(chunks));
	});
var author$project$Animation$Render$pathCmdValue = function (cmd) {
	var renderPoints = function (coords) {
		return A2(
			elm$core$String$join,
			' ',
			A2(
				elm$core$List$map,
				function (_n11) {
					var x = _n11.a;
					var y = _n11.b;
					return elm$core$String$fromFloat(x.cZ) + (',' + elm$core$String$fromFloat(y.cZ));
				},
				coords));
	};
	switch (cmd.$) {
		case 0:
			var x = cmd.a;
			var y = cmd.b;
			return 'm ' + (elm$core$String$fromFloat(x.cZ) + (',' + elm$core$String$fromFloat(y.cZ)));
		case 1:
			var x = cmd.a;
			var y = cmd.b;
			return 'M ' + (elm$core$String$fromFloat(x.cZ) + (',' + elm$core$String$fromFloat(y.cZ)));
		case 2:
			var x = cmd.a;
			var y = cmd.b;
			return 'l ' + (elm$core$String$fromFloat(x.cZ) + (',' + elm$core$String$fromFloat(y.cZ)));
		case 3:
			var x = cmd.a;
			var y = cmd.b;
			return 'L ' + (elm$core$String$fromFloat(x.cZ) + (',' + elm$core$String$fromFloat(y.cZ)));
		case 4:
			var a = cmd.a;
			return 'h ' + elm$core$String$fromFloat(a.cZ);
		case 5:
			var a = cmd.a;
			return 'H ' + elm$core$String$fromFloat(a.cZ);
		case 6:
			var a = cmd.a;
			return 'v ' + elm$core$String$fromFloat(a.cZ);
		case 7:
			var a = cmd.a;
			return 'V ' + elm$core$String$fromFloat(a.cZ);
		case 8:
			var control1 = cmd.a.ak;
			var control2 = cmd.a.al;
			var point = cmd.a.w;
			var _n1 = point;
			var p1x = _n1.a;
			var p1y = _n1.b;
			var _n2 = control2;
			var c2x = _n2.a;
			var c2y = _n2.b;
			var _n3 = control1;
			var c1x = _n3.a;
			var c1y = _n3.b;
			return 'c ' + (elm$core$String$fromFloat(c1x.cZ) + (' ' + (elm$core$String$fromFloat(c1y.cZ) + (', ' + (elm$core$String$fromFloat(c2x.cZ) + (' ' + (elm$core$String$fromFloat(c2y.cZ) + (', ' + (elm$core$String$fromFloat(p1x.cZ) + (' ' + elm$core$String$fromFloat(p1y.cZ)))))))))));
		case 9:
			var control1 = cmd.a.ak;
			var control2 = cmd.a.al;
			var point = cmd.a.w;
			var _n4 = point;
			var p1x = _n4.a;
			var p1y = _n4.b;
			var _n5 = control2;
			var c2x = _n5.a;
			var c2y = _n5.b;
			var _n6 = control1;
			var c1x = _n6.a;
			var c1y = _n6.b;
			return 'C ' + (elm$core$String$fromFloat(c1x.cZ) + (' ' + (elm$core$String$fromFloat(c1y.cZ) + (', ' + (elm$core$String$fromFloat(c2x.cZ) + (' ' + (elm$core$String$fromFloat(c2y.cZ) + (', ' + (elm$core$String$fromFloat(p1x.cZ) + (' ' + elm$core$String$fromFloat(p1y.cZ)))))))))));
		case 10:
			var control = cmd.a.aj;
			var point = cmd.a.w;
			var _n7 = point;
			var p1x = _n7.a;
			var p1y = _n7.b;
			var _n8 = control;
			var c1x = _n8.a;
			var c1y = _n8.b;
			return 'q ' + (elm$core$String$fromFloat(c1x.cZ) + (' ' + (elm$core$String$fromFloat(c1y.cZ) + (', ' + (elm$core$String$fromFloat(p1x.cZ) + (' ' + elm$core$String$fromFloat(p1y.cZ)))))));
		case 11:
			var control = cmd.a.aj;
			var point = cmd.a.w;
			var _n9 = point;
			var p1x = _n9.a;
			var p1y = _n9.b;
			var _n10 = control;
			var c1x = _n10.a;
			var c1y = _n10.b;
			return 'Q ' + (elm$core$String$fromFloat(c1x.cZ) + (' ' + (elm$core$String$fromFloat(c1y.cZ) + (', ' + (elm$core$String$fromFloat(p1x.cZ) + (' ' + elm$core$String$fromFloat(p1y.cZ)))))));
		case 12:
			var points = cmd.a;
			return 't ' + renderPoints(points);
		case 13:
			var points = cmd.a;
			return 'T ' + renderPoints(points);
		case 14:
			var points = cmd.a;
			return 's ' + renderPoints(points);
		case 15:
			var points = cmd.a;
			return 'S ' + renderPoints(points);
		case 16:
			var arc = cmd.a;
			var deltaAngle = arc.am.cZ - arc.as.cZ;
			if (_Utils_cmp(deltaAngle, 360 - 1.0e-6) > 0) {
				var dy = arc.ar.cZ * elm$core$Basics$sin(
					elm$core$Basics$degrees(arc.as.cZ));
				var dx = arc.ar.cZ * elm$core$Basics$cos(
					elm$core$Basics$degrees(arc.as.cZ));
				return 'A ' + (elm$core$String$fromFloat(arc.ar.cZ) + (',' + (elm$core$String$fromFloat(arc.ar.cZ) + (',0,1,1,' + (elm$core$String$fromFloat(arc.ay.cZ - dx) + (',' + (elm$core$String$fromFloat(arc.az.cZ - dy) + (' A ' + (elm$core$String$fromFloat(arc.ar.cZ) + (',' + (elm$core$String$fromFloat(arc.ar.cZ) + (',0,1,1,' + (elm$core$String$fromFloat(arc.ay.cZ + dx) + (',' + elm$core$String$fromFloat(arc.az.cZ + dy)))))))))))))));
			} else {
				return 'A ' + (elm$core$String$fromFloat(arc.ar.cZ) + (',' + (elm$core$String$fromFloat(arc.ar.cZ) + (' 0 ' + (((deltaAngle >= 180) ? '1' : '0') + (' ' + ('1' + (' ' + (elm$core$String$fromFloat(
					arc.ay.cZ + (arc.ar.cZ * elm$core$Basics$cos(
						elm$core$Basics$degrees(arc.am.cZ)))) + (',' + elm$core$String$fromFloat(
					arc.az.cZ + (arc.ar.cZ * elm$core$Basics$sin(
						elm$core$Basics$degrees(arc.am.cZ))))))))))))));
			}
		case 17:
			var arc = cmd.a;
			var deltaAngle = arc.am.cZ - arc.as.cZ;
			if (_Utils_cmp(deltaAngle, 360 - 1.0e-6) > 0) {
				var dy = arc.ar.cZ * elm$core$Basics$sin(
					elm$core$Basics$degrees(arc.as.cZ));
				var dx = arc.ar.cZ * elm$core$Basics$cos(
					elm$core$Basics$degrees(arc.as.cZ));
				return 'A ' + (elm$core$String$fromFloat(arc.ar.cZ) + (',' + (elm$core$String$fromFloat(arc.ar.cZ) + (',0,1,0,' + (elm$core$String$fromFloat(arc.ay.cZ - dx) + (',' + (elm$core$String$fromFloat(arc.az.cZ - dy) + (' A ' + (elm$core$String$fromFloat(arc.ar.cZ) + (',' + (elm$core$String$fromFloat(arc.ar.cZ) + (',0,1,1,' + (elm$core$String$fromFloat(arc.ay.cZ + dx) + (',' + elm$core$String$fromFloat(arc.az.cZ + dy)))))))))))))));
			} else {
				return 'A ' + (elm$core$String$fromFloat(arc.ar.cZ) + (',' + (elm$core$String$fromFloat(arc.ar.cZ) + (' 0 ' + ((((arc.as.cZ - arc.am.cZ) >= 180) ? '1' : '0') + (' ' + ('0' + (' ' + (elm$core$String$fromFloat(
					arc.ay.cZ + (arc.ar.cZ * elm$core$Basics$cos(arc.am.cZ))) + (',' + elm$core$String$fromFloat(
					arc.az.cZ + (arc.ar.cZ * elm$core$Basics$sin(arc.am.cZ)))))))))))));
			}
		default:
			return 'z';
	}
};
var author$project$Animation$Render$propertyValue = F2(
	function (prop, delim) {
		switch (prop.$) {
			case 0:
				var value = prop.b;
				return value;
			case 1:
				var r = prop.b;
				var g = prop.c;
				var b = prop.d;
				var a = prop.e;
				return 'rgba(' + (elm$core$String$fromInt(
					elm$core$Basics$round(r.cZ)) + (',' + (elm$core$String$fromInt(
					elm$core$Basics$round(g.cZ)) + (',' + (elm$core$String$fromInt(
					elm$core$Basics$round(b.cZ)) + (',' + (elm$core$String$fromFloat(a.cZ) + ')')))))));
			case 2:
				var name = prop.a;
				var inset = prop.b;
				var shadow = prop.c;
				return (inset ? 'inset ' : '') + (elm$core$String$fromFloat(shadow.t.cZ) + ('px' + (' ' + (elm$core$String$fromFloat(shadow.u.cZ) + ('px' + (' ' + (elm$core$String$fromFloat(shadow.s.cZ) + ('px' + (' ' + ((((name === 'text-shadow') || (name === 'drop-shadow')) ? '' : (elm$core$String$fromFloat(shadow.x.cZ) + ('px' + ' '))) + ('rgba(' + (elm$core$String$fromInt(
					elm$core$Basics$round(shadow.m.cZ)) + (', ' + (elm$core$String$fromInt(
					elm$core$Basics$round(shadow.l.cZ)) + (', ' + (elm$core$String$fromInt(
					elm$core$Basics$round(shadow.j.cZ)) + (', ' + (elm$core$String$fromFloat(shadow.i.cZ) + ')'))))))))))))))))));
			case 3:
				var x = prop.b;
				return _Utils_ap(
					elm$core$String$fromFloat(x.cZ),
					x.dx);
			case 4:
				var x = prop.b;
				var y = prop.c;
				return _Utils_ap(
					elm$core$String$fromFloat(x.cZ),
					_Utils_ap(
						x.dx,
						_Utils_ap(
							delim,
							_Utils_ap(
								elm$core$String$fromFloat(y.cZ),
								y.dx))));
			case 5:
				var x = prop.b;
				var y = prop.c;
				var z = prop.d;
				return _Utils_ap(
					elm$core$String$fromFloat(x.cZ),
					_Utils_ap(
						x.dx,
						_Utils_ap(
							delim,
							_Utils_ap(
								elm$core$String$fromFloat(y.cZ),
								_Utils_ap(
									y.dx,
									_Utils_ap(
										delim,
										_Utils_ap(
											elm$core$String$fromFloat(z.cZ),
											z.dx)))))));
			case 6:
				var w = prop.b;
				var x = prop.c;
				var y = prop.d;
				var z = prop.e;
				return _Utils_ap(
					elm$core$String$fromFloat(w.cZ),
					_Utils_ap(
						w.dx,
						_Utils_ap(
							delim,
							_Utils_ap(
								elm$core$String$fromFloat(x.cZ),
								_Utils_ap(
									x.dx,
									_Utils_ap(
										delim,
										_Utils_ap(
											elm$core$String$fromFloat(y.cZ),
											_Utils_ap(
												y.dx,
												_Utils_ap(
													delim,
													_Utils_ap(
														elm$core$String$fromFloat(z.cZ),
														z.dx))))))))));
			case 7:
				var x = prop.b;
				return _Utils_ap(
					elm$core$String$fromFloat(x.cZ),
					x.dx);
			case 8:
				var coords = prop.a;
				return A2(
					elm$core$String$join,
					' ',
					A2(
						elm$core$List$map,
						function (_n1) {
							var x = _n1.a;
							var y = _n1.b;
							return elm$core$String$fromFloat(x.cZ) + (',' + elm$core$String$fromFloat(y.cZ));
						},
						coords));
			default:
				var cmds = prop.a;
				return A2(
					elm$core$String$join,
					' ',
					A2(elm$core$List$map, author$project$Animation$Render$pathCmdValue, cmds));
		}
	});
var elm$virtual_dom$VirtualDom$attribute = F2(
	function (key, value) {
		return A2(
			_VirtualDom_attribute,
			_VirtualDom_noOnOrFormAction(key),
			_VirtualDom_noJavaScriptOrHtmlUri(value));
	});
var elm$html$Html$Attributes$attribute = elm$virtual_dom$VirtualDom$attribute;
var elm$svg$Svg$Attributes$cx = _VirtualDom_attribute('cx');
var elm$svg$Svg$Attributes$cy = _VirtualDom_attribute('cy');
var elm$svg$Svg$Attributes$d = _VirtualDom_attribute('d');
var elm$svg$Svg$Attributes$offset = _VirtualDom_attribute('offset');
var elm$svg$Svg$Attributes$points = _VirtualDom_attribute('points');
var elm$svg$Svg$Attributes$r = _VirtualDom_attribute('r');
var elm$svg$Svg$Attributes$rx = _VirtualDom_attribute('rx');
var elm$svg$Svg$Attributes$ry = _VirtualDom_attribute('ry');
var elm$svg$Svg$Attributes$viewBox = _VirtualDom_attribute('viewBox');
var elm$svg$Svg$Attributes$x = _VirtualDom_attribute('x');
var elm$svg$Svg$Attributes$y = _VirtualDom_attribute('y');
var author$project$Animation$Render$renderAttrs = function (prop) {
	if (A2(
		elm$core$String$startsWith,
		'attr:',
		author$project$Animation$Model$propertyName(prop))) {
		return elm$core$Maybe$Just(
			A2(
				elm$html$Html$Attributes$attribute,
				A2(
					elm$core$String$dropLeft,
					5,
					author$project$Animation$Model$propertyName(prop)),
				A2(author$project$Animation$Render$propertyValue, prop, ' ')));
	} else {
		switch (prop.$) {
			case 8:
				var pts = prop.a;
				return elm$core$Maybe$Just(
					elm$svg$Svg$Attributes$points(
						A2(author$project$Animation$Render$propertyValue, prop, ' ')));
			case 9:
				var cmds = prop.a;
				return elm$core$Maybe$Just(
					elm$svg$Svg$Attributes$d(
						A2(author$project$Animation$Render$propertyValue, prop, ' ')));
			case 3:
				var name = prop.a;
				var m1 = prop.b;
				switch (name) {
					case 'x':
						return elm$core$Maybe$Just(
							elm$svg$Svg$Attributes$x(
								A2(author$project$Animation$Render$propertyValue, prop, ' ')));
					case 'y':
						return elm$core$Maybe$Just(
							elm$svg$Svg$Attributes$y(
								A2(author$project$Animation$Render$propertyValue, prop, ' ')));
					case 'cx':
						return elm$core$Maybe$Just(
							elm$svg$Svg$Attributes$cx(
								A2(author$project$Animation$Render$propertyValue, prop, ' ')));
					case 'cy':
						return elm$core$Maybe$Just(
							elm$svg$Svg$Attributes$cy(
								A2(author$project$Animation$Render$propertyValue, prop, ' ')));
					case 'rx':
						return elm$core$Maybe$Just(
							elm$svg$Svg$Attributes$rx(
								A2(author$project$Animation$Render$propertyValue, prop, ' ')));
					case 'ry':
						return elm$core$Maybe$Just(
							elm$svg$Svg$Attributes$ry(
								A2(author$project$Animation$Render$propertyValue, prop, ' ')));
					case 'r':
						return elm$core$Maybe$Just(
							elm$svg$Svg$Attributes$r(
								A2(author$project$Animation$Render$propertyValue, prop, ' ')));
					case 'offset':
						return elm$core$Maybe$Just(
							elm$svg$Svg$Attributes$offset(
								A2(author$project$Animation$Render$propertyValue, prop, ' ')));
					default:
						return elm$core$Maybe$Nothing;
				}
			case 6:
				var name = prop.a;
				var m1 = prop.b;
				var m2 = prop.c;
				var m3 = prop.d;
				var m4 = prop.e;
				return (name === 'viewBox') ? elm$core$Maybe$Just(
					elm$svg$Svg$Attributes$viewBox(
						A2(author$project$Animation$Render$propertyValue, prop, ' '))) : elm$core$Maybe$Nothing;
			default:
				return elm$core$Maybe$Nothing;
		}
	}
};
var author$project$Animation$Render$isAttr = function (prop) {
	return A2(
		elm$core$String$startsWith,
		'attr:',
		author$project$Animation$Model$propertyName(prop)) || function () {
		switch (prop.$) {
			case 8:
				return true;
			case 9:
				return true;
			case 3:
				var name = prop.a;
				return (name === 'cx') || ((name === 'cy') || ((name === 'x') || ((name === 'y') || ((name === 'rx') || ((name === 'ry') || ((name === 'r') || (name === 'offset')))))));
			case 6:
				var name = prop.a;
				return name === 'viewBox';
			default:
				return false;
		}
	}();
};
var author$project$Animation$Render$isFilter = function (prop) {
	return A2(
		elm$core$List$member,
		author$project$Animation$Model$propertyName(prop),
		_List_fromArray(
			['filter-url', 'blur', 'brightness', 'contrast', 'grayscale', 'hue-rotate', 'invert', 'saturate', 'sepia', 'drop-shadow']));
};
var author$project$Animation$Render$render3dRotation = function (prop) {
	if (prop.$ === 5) {
		var x = prop.b;
		var y = prop.c;
		var z = prop.d;
		return 'rotateX(' + (elm$core$String$fromFloat(x.cZ) + (x.dx + (') rotateY(' + (elm$core$String$fromFloat(y.cZ) + (y.dx + (') rotateZ(' + (elm$core$String$fromFloat(z.cZ) + (z.dx + ')'))))))));
	} else {
		return '';
	}
};
var elm$core$List$isEmpty = function (xs) {
	if (!xs.b) {
		return true;
	} else {
		return false;
	}
};
var author$project$Animation$Render$renderValues = function (_n0) {
	var model = _n0;
	var _n1 = A2(elm$core$List$partition, author$project$Animation$Render$isAttr, model.bP);
	var attrProps = _n1.a;
	var styleProps = _n1.b;
	var _n2 = A3(
		elm$core$List$foldl,
		F2(
			function (prop, _n3) {
				var myStyle = _n3.a;
				var myTransforms = _n3.b;
				var myFilters = _n3.c;
				return author$project$Animation$Render$isTransformation(prop) ? _Utils_Tuple3(
					myStyle,
					_Utils_ap(
						myTransforms,
						_List_fromArray(
							[prop])),
					myFilters) : (author$project$Animation$Render$isFilter(prop) ? _Utils_Tuple3(
					myStyle,
					myTransforms,
					_Utils_ap(
						myFilters,
						_List_fromArray(
							[prop]))) : _Utils_Tuple3(
					_Utils_ap(
						myStyle,
						_List_fromArray(
							[prop])),
					myTransforms,
					myFilters));
			}),
		_Utils_Tuple3(_List_Nil, _List_Nil, _List_Nil),
		styleProps);
	var style = _n2.a;
	var transforms = _n2.b;
	var filters = _n2.c;
	var renderedFilters = elm$core$List$isEmpty(filters) ? _List_Nil : _List_fromArray(
		[
			_Utils_Tuple2(
			'filter',
			A2(
				elm$core$String$join,
				' ',
				A2(
					elm$core$List$map,
					function (prop) {
						var name = author$project$Animation$Model$propertyName(prop);
						return (name === 'filter-url') ? ('url(\"' + (A2(author$project$Animation$Render$propertyValue, prop, ', ') + '\")')) : (author$project$Animation$Model$propertyName(prop) + ('(' + (A2(author$project$Animation$Render$propertyValue, prop, ', ') + ')')));
					},
					filters)))
		]);
	var renderedStyle = A2(
		elm$core$List$map,
		function (prop) {
			return _Utils_Tuple2(
				author$project$Animation$Model$propertyName(prop),
				A2(author$project$Animation$Render$propertyValue, prop, ' '));
		},
		style);
	var renderedTransforms = elm$core$List$isEmpty(transforms) ? _List_Nil : _List_fromArray(
		[
			_Utils_Tuple2(
			'transform',
			A2(
				elm$core$String$join,
				' ',
				A2(
					elm$core$List$map,
					function (prop) {
						return (author$project$Animation$Model$propertyName(prop) === 'rotate3d') ? author$project$Animation$Render$render3dRotation(prop) : (author$project$Animation$Model$propertyName(prop) + ('(' + (A2(author$project$Animation$Render$propertyValue, prop, ', ') + ')')));
					},
					transforms)))
		]);
	return _Utils_Tuple2(
		_Utils_ap(
			renderedTransforms,
			_Utils_ap(renderedFilters, renderedStyle)),
		attrProps);
};
var elm$core$List$append = F2(
	function (xs, ys) {
		if (!ys.b) {
			return xs;
		} else {
			return A3(elm$core$List$foldr, elm$core$List$cons, ys, xs);
		}
	});
var elm$core$List$concat = function (lists) {
	return A3(elm$core$List$foldr, elm$core$List$append, _List_Nil, lists);
};
var elm$core$List$concatMap = F2(
	function (f, list) {
		return elm$core$List$concat(
			A2(elm$core$List$map, f, list));
	});
var elm$virtual_dom$VirtualDom$style = _VirtualDom_style;
var elm$html$Html$Attributes$style = elm$virtual_dom$VirtualDom$style;
var author$project$Animation$Render$render = function (animation) {
	var _n0 = author$project$Animation$Render$renderValues(animation);
	var style = _n0.a;
	var attrProps = _n0.b;
	var otherAttrs = A2(elm$core$List$filterMap, author$project$Animation$Render$renderAttrs, attrProps);
	var styleAttr = A2(
		elm$core$List$map,
		function (_n1) {
			var prop = _n1.a;
			var val = _n1.b;
			return A2(elm$html$Html$Attributes$style, prop, val);
		},
		A2(elm$core$List$concatMap, author$project$Animation$Render$prefix, style));
	return _Utils_ap(styleAttr, otherAttrs);
};
var author$project$Animation$render = author$project$Animation$Render$render;
var elm$svg$Svg$trustedNode = _VirtualDom_nodeNS('http://www.w3.org/2000/svg');
var elm$svg$Svg$g = elm$svg$Svg$trustedNode('g');
var elm$svg$Svg$polygon = elm$svg$Svg$trustedNode('polygon');
var elm$svg$Svg$svg = elm$svg$Svg$trustedNode('svg');
var elm$svg$Svg$Attributes$version = _VirtualDom_attribute('version');
var elm$svg$Svg$Attributes$width = _VirtualDom_attribute('width');
var mdgriffith$stylish_elephants$Internal$Model$AlignX = function (a) {
	return {$: 6, a: a};
};
var mdgriffith$stylish_elephants$Internal$Model$Left = 0;
var mdgriffith$stylish_elephants$Element$alignLeft = mdgriffith$stylish_elephants$Internal$Model$AlignX(0);
var mdgriffith$stylish_elephants$Internal$Model$AlignY = function (a) {
	return {$: 5, a: a};
};
var mdgriffith$stylish_elephants$Internal$Model$Top = 0;
var mdgriffith$stylish_elephants$Element$alignTop = mdgriffith$stylish_elephants$Internal$Model$AlignY(0);
var mdgriffith$stylish_elephants$Internal$Model$Height = function (a) {
	return {$: 8, a: a};
};
var mdgriffith$stylish_elephants$Element$height = mdgriffith$stylish_elephants$Internal$Model$Height;
var mdgriffith$stylish_elephants$Internal$Model$Content = {$: 1};
var mdgriffith$stylish_elephants$Element$shrink = mdgriffith$stylish_elephants$Internal$Model$Content;
var mdgriffith$stylish_elephants$Internal$Model$Width = function (a) {
	return {$: 7, a: a};
};
var mdgriffith$stylish_elephants$Element$width = mdgriffith$stylish_elephants$Internal$Model$Width;
var mdgriffith$stylish_elephants$Internal$Model$Unkeyed = function (a) {
	return {$: 0, a: a};
};
var mdgriffith$stylish_elephants$Internal$Model$AsEl = 2;
var mdgriffith$stylish_elephants$Internal$Model$asEl = 2;
var mdgriffith$stylish_elephants$Internal$Model$Generic = {$: 0};
var mdgriffith$stylish_elephants$Internal$Model$div = mdgriffith$stylish_elephants$Internal$Model$Generic;
var mdgriffith$stylish_elephants$Internal$Flag$Field = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var mdgriffith$stylish_elephants$Internal$Flag$none = A2(mdgriffith$stylish_elephants$Internal$Flag$Field, 0, 0);
var mdgriffith$stylish_elephants$Internal$Style$classes = {bZ: 'a', aP: 'atv', b_: 'ab', b$: 'cx', b0: 'cy', b1: 'acb', b2: 'accx', b3: 'accy', b4: 'acr', a8: 'al', a9: 'ar', b5: 'at', aQ: 'ah', aR: 'av', b6: 's', b8: 'bh', b9: 'b', bb: 'w7', cb: 'bd', cc: 'bdt', aA: 'bn', cd: 'bs', aB: 'cpe', ci: 'cp', cj: 'cpx', ck: 'cpy', F: 'c', aD: 'ctr', aE: 'cb', aF: 'ccx', ai: 'ccy', bg: 'cl', aG: 'cr', cm: 'ct', cn: 'cptr', co: 'ctxt', cv: 'fcs', cw: 'g', cx: 'hbh', ao: 'hc', aY: 'hf', bo: 'hfp', cA: 'hv', cC: 'ic', cE: 'fr', cG: 'iml', cH: 'it', cJ: 'i', cQ: 'notxt', cR: 'ol', cT: 'or', V: 'oq', cX: 'oh', aq: 'pg', bz: 'p', cY: 'ppe', c0: 'ui', L: 'r', c2: 'sb', c3: 'sbx', c4: 'sby', c5: 'sbt', c7: 'e', c9: 'sev', dd: 'sk', q: 't', dg: 'tc', dh: 'w8', di: 'w2', dj: 'w9', dk: 'tj', aO: 'tja', dl: 'tl', dm: 'w3', dn: 'w5', $7: 'w4', dp: 'tr', dq: 'w6', dr: 'w1', ds: 'tun', bU: 'ts', Y: 'clr', dw: 'u', a5: 'wc', bW: 'we', a6: 'wf', bX: 'wfp'};
var mdgriffith$stylish_elephants$Internal$Model$columnClass = mdgriffith$stylish_elephants$Internal$Style$classes.b6 + (' ' + mdgriffith$stylish_elephants$Internal$Style$classes.F);
var mdgriffith$stylish_elephants$Internal$Model$gridClass = mdgriffith$stylish_elephants$Internal$Style$classes.b6 + (' ' + mdgriffith$stylish_elephants$Internal$Style$classes.cw);
var mdgriffith$stylish_elephants$Internal$Model$pageClass = mdgriffith$stylish_elephants$Internal$Style$classes.b6 + (' ' + mdgriffith$stylish_elephants$Internal$Style$classes.aq);
var mdgriffith$stylish_elephants$Internal$Model$paragraphClass = mdgriffith$stylish_elephants$Internal$Style$classes.b6 + (' ' + mdgriffith$stylish_elephants$Internal$Style$classes.bz);
var mdgriffith$stylish_elephants$Internal$Model$rowClass = mdgriffith$stylish_elephants$Internal$Style$classes.b6 + (' ' + mdgriffith$stylish_elephants$Internal$Style$classes.L);
var mdgriffith$stylish_elephants$Internal$Model$singleClass = mdgriffith$stylish_elephants$Internal$Style$classes.b6 + (' ' + mdgriffith$stylish_elephants$Internal$Style$classes.c7);
var mdgriffith$stylish_elephants$Internal$Model$contextClasses = function (context) {
	switch (context) {
		case 0:
			return mdgriffith$stylish_elephants$Internal$Model$rowClass;
		case 1:
			return mdgriffith$stylish_elephants$Internal$Model$columnClass;
		case 2:
			return mdgriffith$stylish_elephants$Internal$Model$singleClass;
		case 3:
			return mdgriffith$stylish_elephants$Internal$Model$gridClass;
		case 4:
			return mdgriffith$stylish_elephants$Internal$Model$paragraphClass;
		default:
			return mdgriffith$stylish_elephants$Internal$Model$pageClass;
	}
};
var elm$virtual_dom$VirtualDom$text = _VirtualDom_text;
var mdgriffith$stylish_elephants$Internal$Model$Keyed = function (a) {
	return {$: 1, a: a};
};
var mdgriffith$stylish_elephants$Internal$Model$NoStyleSheet = {$: 0};
var mdgriffith$stylish_elephants$Internal$Model$Styled = function (a) {
	return {$: 1, a: a};
};
var mdgriffith$stylish_elephants$Internal$Model$Unstyled = function (a) {
	return {$: 0, a: a};
};
var mdgriffith$stylish_elephants$Internal$Model$AsParagraph = 4;
var mdgriffith$stylish_elephants$Internal$Model$asParagraph = 4;
var elm$html$Html$div = _VirtualDom_node('div');
var elm$html$Html$p = _VirtualDom_node('p');
var elm$html$Html$s = _VirtualDom_node('s');
var elm$html$Html$u = _VirtualDom_node('u');
var elm$json$Json$Encode$string = _Json_wrap;
var elm$html$Html$Attributes$stringProperty = F2(
	function (key, string) {
		return A2(
			_VirtualDom_property,
			key,
			elm$json$Json$Encode$string(string));
	});
var elm$html$Html$Attributes$class = elm$html$Html$Attributes$stringProperty('className');
var elm$virtual_dom$VirtualDom$keyedNode = function (tag) {
	return _VirtualDom_keyedNode(
		_VirtualDom_noScript(tag));
};
var elm$virtual_dom$VirtualDom$node = function (tag) {
	return _VirtualDom_node(
		_VirtualDom_noScript(tag));
};
var elm$core$Bitwise$shiftLeftBy = _Bitwise_shiftLeftBy;
var mdgriffith$stylish_elephants$Internal$Flag$Flag = function (a) {
	return {$: 0, a: a};
};
var mdgriffith$stylish_elephants$Internal$Flag$Second = function (a) {
	return {$: 1, a: a};
};
var mdgriffith$stylish_elephants$Internal$Flag$flag = function (i) {
	return (i > 31) ? mdgriffith$stylish_elephants$Internal$Flag$Second(1 << (i - 32)) : mdgriffith$stylish_elephants$Internal$Flag$Flag(1 << i);
};
var mdgriffith$stylish_elephants$Internal$Flag$alignBottom = mdgriffith$stylish_elephants$Internal$Flag$flag(41);
var mdgriffith$stylish_elephants$Internal$Flag$alignRight = mdgriffith$stylish_elephants$Internal$Flag$flag(40);
var mdgriffith$stylish_elephants$Internal$Flag$centerX = mdgriffith$stylish_elephants$Internal$Flag$flag(42);
var mdgriffith$stylish_elephants$Internal$Flag$centerY = mdgriffith$stylish_elephants$Internal$Flag$flag(43);
var mdgriffith$stylish_elephants$Internal$Flag$heightBetween = mdgriffith$stylish_elephants$Internal$Flag$flag(45);
var mdgriffith$stylish_elephants$Internal$Flag$heightFill = mdgriffith$stylish_elephants$Internal$Flag$flag(37);
var elm$core$Bitwise$and = _Bitwise_and;
var mdgriffith$stylish_elephants$Internal$Flag$present = F2(
	function (myFlag, _n0) {
		var fieldOne = _n0.a;
		var fieldTwo = _n0.b;
		if (!myFlag.$) {
			var first = myFlag.a;
			return _Utils_eq(first & fieldOne, first);
		} else {
			var second = myFlag.a;
			return _Utils_eq(second & fieldTwo, second);
		}
	});
var mdgriffith$stylish_elephants$Internal$Flag$widthBetween = mdgriffith$stylish_elephants$Internal$Flag$flag(44);
var mdgriffith$stylish_elephants$Internal$Flag$widthFill = mdgriffith$stylish_elephants$Internal$Flag$flag(39);
var elm$core$Set$Set_elm_builtin = elm$core$Basics$identity;
var elm$core$Set$empty = elm$core$Dict$empty;
var elm$core$Set$insert = F2(
	function (key, _n0) {
		var dict = _n0;
		return A3(elm$core$Dict$insert, key, 0, dict);
	});
var elm$core$Dict$get = F2(
	function (targetKey, dict) {
		get:
		while (true) {
			if (dict.$ === -2) {
				return elm$core$Maybe$Nothing;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var _n1 = A2(elm$core$Basics$compare, targetKey, key);
				switch (_n1) {
					case 0:
						var $temp$targetKey = targetKey,
							$temp$dict = left;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
					case 1:
						return elm$core$Maybe$Just(value);
					default:
						var $temp$targetKey = targetKey,
							$temp$dict = right;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
				}
			}
		}
	});
var elm$core$Dict$member = F2(
	function (key, dict) {
		var _n0 = A2(elm$core$Dict$get, key, dict);
		if (!_n0.$) {
			return true;
		} else {
			return false;
		}
	});
var elm$core$Set$member = F2(
	function (key, _n0) {
		var dict = _n0;
		return A2(elm$core$Dict$member, key, dict);
	});
var mdgriffith$stylish_elephants$Internal$Model$lengthClassName = function (x) {
	switch (x.$) {
		case 0:
			var px = x.a;
			return elm$core$String$fromInt(px) + 'px';
		case 1:
			return 'auto';
		case 2:
			var i = x.a;
			return elm$core$String$fromInt(i) + 'fr';
		case 3:
			var min = x.a;
			var len = x.b;
			return 'min' + (elm$core$String$fromInt(min) + mdgriffith$stylish_elephants$Internal$Model$lengthClassName(len));
		default:
			var max = x.a;
			var len = x.b;
			return 'max' + (elm$core$String$fromInt(max) + mdgriffith$stylish_elephants$Internal$Model$lengthClassName(len));
	}
};
var mdgriffith$stylish_elephants$Internal$Model$floatClass = function (x) {
	return elm$core$String$fromInt(
		elm$core$Basics$round(x * 255));
};
var mdgriffith$stylish_elephants$Internal$Model$transformClass = function (transform) {
	switch (transform.$) {
		case 0:
			return elm$core$Maybe$Nothing;
		case 1:
			var _n1 = transform.a;
			var x = _n1.a;
			var y = _n1.b;
			var z = _n1.c;
			return elm$core$Maybe$Just(
				'mv-' + (mdgriffith$stylish_elephants$Internal$Model$floatClass(x) + ('-' + (mdgriffith$stylish_elephants$Internal$Model$floatClass(y) + ('-' + mdgriffith$stylish_elephants$Internal$Model$floatClass(z))))));
		default:
			var _n2 = transform.a;
			var tx = _n2.a;
			var ty = _n2.b;
			var tz = _n2.c;
			var _n3 = transform.b;
			var sx = _n3.a;
			var sy = _n3.b;
			var sz = _n3.c;
			var _n4 = transform.c;
			var ox = _n4.a;
			var oy = _n4.b;
			var oz = _n4.c;
			var angle = transform.d;
			return elm$core$Maybe$Just(
				'tfrm-' + (mdgriffith$stylish_elephants$Internal$Model$floatClass(tx) + ('-' + (mdgriffith$stylish_elephants$Internal$Model$floatClass(ty) + ('-' + (mdgriffith$stylish_elephants$Internal$Model$floatClass(tz) + ('-' + (mdgriffith$stylish_elephants$Internal$Model$floatClass(sx) + ('-' + (mdgriffith$stylish_elephants$Internal$Model$floatClass(sy) + ('-' + (mdgriffith$stylish_elephants$Internal$Model$floatClass(sz) + ('-' + (mdgriffith$stylish_elephants$Internal$Model$floatClass(ox) + ('-' + (mdgriffith$stylish_elephants$Internal$Model$floatClass(oy) + ('-' + (mdgriffith$stylish_elephants$Internal$Model$floatClass(oz) + ('-' + mdgriffith$stylish_elephants$Internal$Model$floatClass(angle))))))))))))))))))));
	}
};
var mdgriffith$stylish_elephants$Internal$Model$getStyleName = function (style) {
	switch (style.$) {
		case 12:
			var name = style.a;
			return name;
		case 11:
			var name = style.a;
			var o = style.b;
			return name;
		case 0:
			var _class = style.a;
			return _class;
		case 1:
			var name = style.a;
			return name;
		case 2:
			var i = style.a;
			return 'font-size-' + elm$core$String$fromInt(i);
		case 3:
			var _class = style.a;
			return _class;
		case 4:
			var _class = style.a;
			return _class;
		case 5:
			var cls = style.a;
			var x = style.b;
			var y = style.c;
			return cls;
		case 6:
			var cls = style.a;
			var top = style.b;
			var right = style.c;
			var bottom = style.d;
			var left = style.e;
			return cls;
		case 7:
			var template = style.a;
			return 'grid-rows-' + (A2(
				elm$core$String$join,
				'-',
				A2(elm$core$List$map, mdgriffith$stylish_elephants$Internal$Model$lengthClassName, template.c1)) + ('-cols-' + (A2(
				elm$core$String$join,
				'-',
				A2(elm$core$List$map, mdgriffith$stylish_elephants$Internal$Model$lengthClassName, template.o)) + ('-space-x-' + (mdgriffith$stylish_elephants$Internal$Model$lengthClassName(template.da.a) + ('-space-y-' + mdgriffith$stylish_elephants$Internal$Model$lengthClassName(template.da.b)))))));
		case 8:
			var pos = style.a;
			return 'gp grid-pos-' + (elm$core$String$fromInt(pos.L) + ('-' + (elm$core$String$fromInt(pos.cl) + ('-' + (elm$core$String$fromInt(pos.D) + ('-' + elm$core$String$fromInt(pos.G)))))));
		case 10:
			var selector = style.a;
			var subStyle = style.b;
			var name = function () {
				switch (selector) {
					case 0:
						return 'fs';
					case 1:
						return 'hv';
					default:
						return 'act';
				}
			}();
			return A2(
				elm$core$String$join,
				' ',
				A2(
					elm$core$List$map,
					function (sty) {
						return mdgriffith$stylish_elephants$Internal$Model$getStyleName(sty) + ('-' + name);
					},
					subStyle));
		default:
			var x = style.a;
			return A2(
				elm$core$Maybe$withDefault,
				'',
				mdgriffith$stylish_elephants$Internal$Model$transformClass(x));
	}
};
var mdgriffith$stylish_elephants$Internal$Model$reduceStyles = F2(
	function (style, _n0) {
		var cache = _n0.a;
		var existing = _n0.b;
		var styleName = mdgriffith$stylish_elephants$Internal$Model$getStyleName(style);
		return A2(elm$core$Set$member, styleName, cache) ? _Utils_Tuple2(cache, existing) : _Utils_Tuple2(
			A2(elm$core$Set$insert, styleName, cache),
			A2(elm$core$List$cons, style, existing));
	});
var elm$core$Maybe$map = F2(
	function (f, maybe) {
		if (!maybe.$) {
			var value = maybe.a;
			return elm$core$Maybe$Just(
				f(value));
		} else {
			return elm$core$Maybe$Nothing;
		}
	});
var elm$core$Tuple$mapFirst = F2(
	function (func, _n0) {
		var x = _n0.a;
		var y = _n0.b;
		return _Utils_Tuple2(
			func(x),
			y);
	});
var elm$core$Tuple$mapSecond = F2(
	function (func, _n0) {
		var x = _n0.a;
		var y = _n0.b;
		return _Utils_Tuple2(
			x,
			func(y));
	});
var mdgriffith$stylish_elephants$Internal$Model$Property = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var mdgriffith$stylish_elephants$Internal$Model$Style = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var mdgriffith$stylish_elephants$Internal$Model$formatColor = function (_n0) {
	var red = _n0.a;
	var green = _n0.b;
	var blue = _n0.c;
	var alpha = _n0.d;
	return 'rgba(' + (elm$core$String$fromInt(
		elm$core$Basics$round(red * 255)) + ((',' + elm$core$String$fromInt(
		elm$core$Basics$round(green * 255))) + ((',' + elm$core$String$fromInt(
		elm$core$Basics$round(blue * 255))) + (',' + (elm$core$String$fromFloat(alpha) + ')')))));
};
var mdgriffith$stylish_elephants$Internal$Model$formatBoxShadow = function (shadow) {
	return A2(
		elm$core$String$join,
		' ',
		A2(
			elm$core$List$filterMap,
			elm$core$Basics$identity,
			_List_fromArray(
				[
					shadow.bs ? elm$core$Maybe$Just('inset') : elm$core$Maybe$Nothing,
					elm$core$Maybe$Just(
					elm$core$String$fromFloat(shadow.bw.a) + 'px'),
					elm$core$Maybe$Just(
					elm$core$String$fromFloat(shadow.bw.b) + 'px'),
					elm$core$Maybe$Just(
					elm$core$String$fromFloat(shadow.s) + 'px'),
					elm$core$Maybe$Just(
					elm$core$String$fromFloat(shadow.x) + 'px'),
					elm$core$Maybe$Just(
					mdgriffith$stylish_elephants$Internal$Model$formatColor(shadow.d))
				])));
};
var mdgriffith$stylish_elephants$Internal$Style$dot = function (c) {
	return '.' + c;
};
var mdgriffith$stylish_elephants$Internal$Model$renderFocusStyle = function (focus) {
	return A2(
		mdgriffith$stylish_elephants$Internal$Model$Style,
		mdgriffith$stylish_elephants$Internal$Style$classes.b6 + (':focus .focusable, ' + (mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b6) + '.focusable:focus')),
		A2(
			elm$core$List$filterMap,
			elm$core$Basics$identity,
			_List_fromArray(
				[
					A2(
					elm$core$Maybe$map,
					function (color) {
						return A2(
							mdgriffith$stylish_elephants$Internal$Model$Property,
							'border-color',
							mdgriffith$stylish_elephants$Internal$Model$formatColor(color));
					},
					focus.ca),
					A2(
					elm$core$Maybe$map,
					function (color) {
						return A2(
							mdgriffith$stylish_elephants$Internal$Model$Property,
							'background-color',
							mdgriffith$stylish_elephants$Internal$Model$formatColor(color));
					},
					focus.ag),
					A2(
					elm$core$Maybe$map,
					function (shadow) {
						return A2(
							mdgriffith$stylish_elephants$Internal$Model$Property,
							'box-shadow',
							mdgriffith$stylish_elephants$Internal$Model$formatBoxShadow(
								{
									s: shadow.s,
									d: shadow.d,
									bs: false,
									bw: A2(
										elm$core$Tuple$mapSecond,
										elm$core$Basics$toFloat,
										A2(elm$core$Tuple$mapFirst, elm$core$Basics$toFloat, shadow.bw)),
									x: shadow.x
								}));
					},
					focus.c6),
					elm$core$Maybe$Just(
					A2(mdgriffith$stylish_elephants$Internal$Model$Property, 'outline', 'none'))
				])));
};
var mdgriffith$stylish_elephants$Internal$Style$Batch = function (a) {
	return {$: 5, a: a};
};
var mdgriffith$stylish_elephants$Internal$Style$Child = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var mdgriffith$stylish_elephants$Internal$Style$Class = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var mdgriffith$stylish_elephants$Internal$Style$Descriptor = F2(
	function (a, b) {
		return {$: 3, a: a, b: b};
	});
var mdgriffith$stylish_elephants$Internal$Style$Left = 3;
var mdgriffith$stylish_elephants$Internal$Style$Prop = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var mdgriffith$stylish_elephants$Internal$Style$Right = 2;
var mdgriffith$stylish_elephants$Internal$Style$Self = elm$core$Basics$identity;
var mdgriffith$stylish_elephants$Internal$Style$Supports = F2(
	function (a, b) {
		return {$: 2, a: a, b: b};
	});
var mdgriffith$stylish_elephants$Internal$Style$Content = elm$core$Basics$identity;
var mdgriffith$stylish_elephants$Internal$Style$Bottom = 1;
var mdgriffith$stylish_elephants$Internal$Style$CenterX = 4;
var mdgriffith$stylish_elephants$Internal$Style$CenterY = 5;
var mdgriffith$stylish_elephants$Internal$Style$Top = 0;
var mdgriffith$stylish_elephants$Internal$Style$alignments = _List_fromArray(
	[0, 1, 2, 3, 4, 5]);
var mdgriffith$stylish_elephants$Internal$Style$contentName = function (desc) {
	switch (desc) {
		case 0:
			var _n1 = desc;
			return mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cm);
		case 1:
			var _n2 = desc;
			return mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.aE);
		case 2:
			var _n3 = desc;
			return mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.aG);
		case 3:
			var _n4 = desc;
			return mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.bg);
		case 4:
			var _n5 = desc;
			return mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.aF);
		default:
			var _n6 = desc;
			return mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.ai);
	}
};
var mdgriffith$stylish_elephants$Internal$Style$selfName = function (desc) {
	switch (desc) {
		case 0:
			var _n1 = desc;
			return mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b5);
		case 1:
			var _n2 = desc;
			return mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b_);
		case 2:
			var _n3 = desc;
			return mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.a9);
		case 3:
			var _n4 = desc;
			return mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.a8);
		case 4:
			var _n5 = desc;
			return mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b$);
		default:
			var _n6 = desc;
			return mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b0);
	}
};
var mdgriffith$stylish_elephants$Internal$Style$describeAlignment = function (values) {
	var createDescription = function (alignment) {
		var _n0 = values(alignment);
		var content = _n0.a;
		var indiv = _n0.b;
		return _List_fromArray(
			[
				A2(
				mdgriffith$stylish_elephants$Internal$Style$Descriptor,
				mdgriffith$stylish_elephants$Internal$Style$contentName(alignment),
				content),
				A2(
				mdgriffith$stylish_elephants$Internal$Style$Child,
				mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b6),
				_List_fromArray(
					[
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$selfName(alignment),
						indiv)
					]))
			]);
	};
	return mdgriffith$stylish_elephants$Internal$Style$Batch(
		A2(elm$core$List$concatMap, createDescription, mdgriffith$stylish_elephants$Internal$Style$alignments));
};
var mdgriffith$stylish_elephants$Internal$Style$gridAlignments = function (values) {
	var createDescription = function (alignment) {
		return _List_fromArray(
			[
				A2(
				mdgriffith$stylish_elephants$Internal$Style$Child,
				mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b6),
				_List_fromArray(
					[
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$selfName(alignment),
						values(alignment))
					]))
			]);
	};
	return mdgriffith$stylish_elephants$Internal$Style$Batch(
		A2(elm$core$List$concatMap, createDescription, mdgriffith$stylish_elephants$Internal$Style$alignments));
};
var mdgriffith$stylish_elephants$Internal$Style$Above = 0;
var mdgriffith$stylish_elephants$Internal$Style$Behind = 5;
var mdgriffith$stylish_elephants$Internal$Style$Below = 1;
var mdgriffith$stylish_elephants$Internal$Style$OnLeft = 3;
var mdgriffith$stylish_elephants$Internal$Style$OnRight = 2;
var mdgriffith$stylish_elephants$Internal$Style$Within = 4;
var mdgriffith$stylish_elephants$Internal$Style$locations = function () {
	var loc = 0;
	var _n0 = function () {
		switch (loc) {
			case 0:
				return 0;
			case 1:
				return 0;
			case 2:
				return 0;
			case 3:
				return 0;
			case 4:
				return 0;
			default:
				return 0;
		}
	}();
	return _List_fromArray(
		[0, 1, 2, 3, 4, 5]);
}();
var mdgriffith$stylish_elephants$Internal$Style$overrides = '@media screen and (-ms-high-contrast: active), (-ms-high-contrast: none) {' + (mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b6) + (mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.L) + (' > ' + (mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b6) + (' { flex-basis: auto !important; } ' + (mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b6) + (mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.L) + (' > ' + (mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b6) + (mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.aD) + ' { flex-basis: auto !important; }}'))))))))));
var elm$core$String$concat = function (strings) {
	return A2(elm$core$String$join, '', strings);
};
var mdgriffith$stylish_elephants$Internal$Style$Intermediate = elm$core$Basics$identity;
var mdgriffith$stylish_elephants$Internal$Style$emptyIntermediate = F2(
	function (selector, closing) {
		return {aC: closing, f: _List_Nil, K: _List_Nil, B: selector};
	});
var mdgriffith$stylish_elephants$Internal$Style$renderRules = F2(
	function (_n0, rulesToRender) {
		var parent = _n0;
		var generateIntermediates = F2(
			function (rule, rendered) {
				switch (rule.$) {
					case 0:
						var name = rule.a;
						var val = rule.b;
						return _Utils_update(
							rendered,
							{
								K: A2(
									elm$core$List$cons,
									_Utils_Tuple2(name, val),
									rendered.K)
							});
					case 2:
						var _n2 = rule.a;
						var prop = _n2.a;
						var value = _n2.b;
						var props = rule.b;
						return _Utils_update(
							rendered,
							{
								f: A2(
									elm$core$List$cons,
									{aC: '\n}', f: _List_Nil, K: props, B: '@supports (' + (prop + (':' + (value + (') {' + parent.B))))},
									rendered.f)
							});
					case 4:
						var selector = rule.a;
						var adjRules = rule.b;
						return _Utils_update(
							rendered,
							{
								f: A2(
									elm$core$List$cons,
									A2(
										mdgriffith$stylish_elephants$Internal$Style$renderRules,
										A2(mdgriffith$stylish_elephants$Internal$Style$emptyIntermediate, parent.B + (' + ' + selector), ''),
										adjRules),
									rendered.f)
							});
					case 1:
						var child = rule.a;
						var childRules = rule.b;
						return _Utils_update(
							rendered,
							{
								f: A2(
									elm$core$List$cons,
									A2(
										mdgriffith$stylish_elephants$Internal$Style$renderRules,
										A2(mdgriffith$stylish_elephants$Internal$Style$emptyIntermediate, parent.B + (' > ' + child), ''),
										childRules),
									rendered.f)
							});
					case 3:
						var descriptor = rule.a;
						var descriptorRules = rule.b;
						return _Utils_update(
							rendered,
							{
								f: A2(
									elm$core$List$cons,
									A2(
										mdgriffith$stylish_elephants$Internal$Style$renderRules,
										A2(
											mdgriffith$stylish_elephants$Internal$Style$emptyIntermediate,
											_Utils_ap(parent.B, descriptor),
											''),
										descriptorRules),
									rendered.f)
							});
					default:
						var batched = rule.a;
						return _Utils_update(
							rendered,
							{
								f: A2(
									elm$core$List$cons,
									A2(
										mdgriffith$stylish_elephants$Internal$Style$renderRules,
										A2(mdgriffith$stylish_elephants$Internal$Style$emptyIntermediate, parent.B, ''),
										batched),
									rendered.f)
							});
				}
			});
		return A3(elm$core$List$foldr, generateIntermediates, parent, rulesToRender);
	});
var mdgriffith$stylish_elephants$Internal$Style$renderCompact = function (styleClasses) {
	var renderValues = function (values) {
		return elm$core$String$concat(
			A2(
				elm$core$List$map,
				function (_n3) {
					var x = _n3.a;
					var y = _n3.b;
					return x + (':' + (y + ';'));
				},
				values));
	};
	var renderClass = function (rule) {
		var _n2 = rule.K;
		if (!_n2.b) {
			return '';
		} else {
			return rule.B + ('{' + (renderValues(rule.K) + (rule.aC + '}')));
		}
	};
	var renderIntermediate = function (_n0) {
		var rule = _n0;
		return _Utils_ap(
			renderClass(rule),
			elm$core$String$concat(
				A2(elm$core$List$map, renderIntermediate, rule.f)));
	};
	return elm$core$String$concat(
		A2(
			elm$core$List$map,
			renderIntermediate,
			A3(
				elm$core$List$foldr,
				F2(
					function (_n1, existing) {
						var name = _n1.a;
						var styleRules = _n1.b;
						return A2(
							elm$core$List$cons,
							A2(
								mdgriffith$stylish_elephants$Internal$Style$renderRules,
								A2(mdgriffith$stylish_elephants$Internal$Style$emptyIntermediate, name, ''),
								styleRules),
							existing);
					}),
				_List_Nil,
				styleClasses)));
};
var mdgriffith$stylish_elephants$Internal$Style$rules = _Utils_ap(
	mdgriffith$stylish_elephants$Internal$Style$overrides,
	mdgriffith$stylish_elephants$Internal$Style$renderCompact(
		_List_fromArray(
			[
				A2(
				mdgriffith$stylish_elephants$Internal$Style$Class,
				'html,body',
				_List_fromArray(
					[
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'height', '100%'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'padding', '0'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin', '0')
					])),
				A2(
				mdgriffith$stylish_elephants$Internal$Style$Class,
				_Utils_ap(
					mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b6),
					_Utils_ap(
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.c7),
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cC))),
				_List_fromArray(
					[
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'block')
					])),
				A2(
				mdgriffith$stylish_elephants$Internal$Style$Class,
				mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b6) + ':focus',
				_List_fromArray(
					[
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'outline', 'none')
					])),
				A2(
				mdgriffith$stylish_elephants$Internal$Style$Class,
				mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.c0),
				_List_fromArray(
					[
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'width', '100%'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'height', 'auto'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'min-height', '100%'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'z-index', '0'),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						_Utils_ap(
							mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b6),
							mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.aY)),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'height', '100%'),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.aY),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'height', '100%')
									]))
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Child,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cE),
						_List_fromArray(
							[
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Descriptor,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b6),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'position', 'fixed')
									]))
							]))
					])),
				A2(
				mdgriffith$stylish_elephants$Internal$Style$Class,
				mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b6),
				_List_fromArray(
					[
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'position', 'relative'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'border', 'none'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-shrink', '0'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'flex'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-direction', 'row'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-basis', 'auto'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'resize', 'none'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'box-sizing', 'border-box'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin', '0'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'padding', '0'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'border-width', '0'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'border-style', 'solid'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'font-size', 'inherit'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'color', 'inherit'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'font-family', 'inherit'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'line-height', '1'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'font-weight', 'inherit'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'text-decoration', 'none'),
						A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'font-style', 'inherit'),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cQ),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, '-moz-user-select', 'none'),
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, '-webkit-user-select', 'none'),
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, '-ms-user-select', 'none'),
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'user-select', 'none')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cn),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'cursor', 'pointer')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.co),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'cursor', 'text')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cY),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'pointer-events', 'none !important')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.aB),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'pointer-events', 'auto !important')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.Y),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'opacity', '0')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.V),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'opacity', '1')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(
							_Utils_ap(mdgriffith$stylish_elephants$Internal$Style$classes.cA, mdgriffith$stylish_elephants$Internal$Style$classes.Y)) + ':hover',
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'opacity', '0')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(
							_Utils_ap(mdgriffith$stylish_elephants$Internal$Style$classes.cA, mdgriffith$stylish_elephants$Internal$Style$classes.V)) + ':hover',
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'opacity', '1')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(
							_Utils_ap(mdgriffith$stylish_elephants$Internal$Style$classes.cv, mdgriffith$stylish_elephants$Internal$Style$classes.Y)) + ':focus',
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'opacity', '0')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(
							_Utils_ap(mdgriffith$stylish_elephants$Internal$Style$classes.cv, mdgriffith$stylish_elephants$Internal$Style$classes.V)) + ':focus',
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'opacity', '1')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(
							_Utils_ap(mdgriffith$stylish_elephants$Internal$Style$classes.aP, mdgriffith$stylish_elephants$Internal$Style$classes.Y)) + ':active',
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'opacity', '0')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(
							_Utils_ap(mdgriffith$stylish_elephants$Internal$Style$classes.aP, mdgriffith$stylish_elephants$Internal$Style$classes.V)) + ':active',
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'opacity', '1')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.bU),
						_List_fromArray(
							[
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Prop,
								'transition',
								A2(
									elm$core$String$join,
									', ',
									A2(
										elm$core$List$map,
										function (x) {
											return x + ' 160ms';
										},
										_List_fromArray(
											['transform', 'opacity', 'filter', 'background-color', 'color', 'font-size']))))
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.c2),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'overflow', 'auto'),
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-shrink', '1')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.c3),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'overflow-x', 'auto'),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Descriptor,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.L),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-shrink', '1')
									]))
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.c4),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'overflow-y', 'auto'),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Descriptor,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.F),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-shrink', '1')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Descriptor,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.c7),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-shrink', '1')
									]))
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.ci),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'overflow', 'hidden')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cj),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'overflow-x', 'hidden')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.ck),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'overflow-y', 'hidden')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.a5),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'width', 'auto')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.aA),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'border-width', '0')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cb),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'border-style', 'dashed')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cc),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'border-style', 'dotted')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cd),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'border-style', 'solid')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.q),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'white-space', 'pre'),
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'inline-block')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cH),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'line-height', '1.05')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.c7),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'flex'),
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-direction', 'column'),
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'white-space', 'pre'),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Descriptor,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cx),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'z-index', '0'),
										A2(
										mdgriffith$stylish_elephants$Internal$Style$Child,
										mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b8),
										_List_fromArray(
											[
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'z-index', '-1')
											]))
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Descriptor,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.c5),
								_List_fromArray(
									[
										A2(
										mdgriffith$stylish_elephants$Internal$Style$Child,
										mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.q),
										_List_fromArray(
											[
												A2(
												mdgriffith$stylish_elephants$Internal$Style$Descriptor,
												mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.aY),
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-grow', '0')
													])),
												A2(
												mdgriffith$stylish_elephants$Internal$Style$Descriptor,
												mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.a6),
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-self', 'auto !important')
													]))
											]))
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.ao),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'height', 'auto')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.aY),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-grow', '100000')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.a6),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'width', '100%')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.a5),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-self', 'flex-start')
									])),
								mdgriffith$stylish_elephants$Internal$Style$describeAlignment(
								function (alignment) {
									switch (alignment) {
										case 0:
											return _Utils_Tuple2(
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'justify-content', 'flex-start')
													]),
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin-bottom', 'auto !important'),
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin-top', '0 !important')
													]));
										case 1:
											return _Utils_Tuple2(
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'justify-content', 'flex-end')
													]),
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin-top', 'auto !important'),
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin-bottom', '0 !important')
													]));
										case 2:
											return _Utils_Tuple2(
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-items', 'flex-end')
													]),
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-self', 'flex-end')
													]));
										case 3:
											return _Utils_Tuple2(
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-items', 'flex-start')
													]),
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-self', 'flex-start')
													]));
										case 4:
											return _Utils_Tuple2(
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-items', 'center')
													]),
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-self', 'center')
													]));
										default:
											return _Utils_Tuple2(
												_List_fromArray(
													[
														A2(
														mdgriffith$stylish_elephants$Internal$Style$Child,
														mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b6),
														_List_fromArray(
															[
																A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin-top', 'auto'),
																A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin-bottom', 'auto')
															]))
													]),
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin-top', 'auto !important'),
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin-bottom', 'auto !important')
													]));
									}
								})
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.L),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'flex'),
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-direction', 'row'),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b6),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-basis', '0%'),
										A2(
										mdgriffith$stylish_elephants$Internal$Style$Descriptor,
										mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.bW),
										_List_fromArray(
											[
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-basis', 'auto')
											]))
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.aY),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-self', 'stretch !important')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.bo),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-self', 'stretch !important')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.a6),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-grow', '100000')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.aD),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-grow', '0'),
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-basis', 'auto'),
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-self', 'stretch')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								'u:first-of-type.' + mdgriffith$stylish_elephants$Internal$Style$classes.b4,
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-grow', '1')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								's:first-of-type.' + mdgriffith$stylish_elephants$Internal$Style$classes.b2,
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-grow', '1'),
										A2(
										mdgriffith$stylish_elephants$Internal$Style$Child,
										mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b$),
										_List_fromArray(
											[
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin-left', 'auto !important')
											]))
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								's:last-of-type.' + mdgriffith$stylish_elephants$Internal$Style$classes.b2,
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-grow', '1'),
										A2(
										mdgriffith$stylish_elephants$Internal$Style$Child,
										mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b$),
										_List_fromArray(
											[
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin-right', 'auto !important')
											]))
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								's:only-of-type.' + mdgriffith$stylish_elephants$Internal$Style$classes.b2,
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-grow', '1'),
										A2(
										mdgriffith$stylish_elephants$Internal$Style$Child,
										mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b0),
										_List_fromArray(
											[
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin-top', 'auto !important'),
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin-bottom', 'auto !important')
											]))
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								's:last-of-type.' + (mdgriffith$stylish_elephants$Internal$Style$classes.b2 + ' ~ u'),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-grow', '0')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								'u:first-of-type.' + (mdgriffith$stylish_elephants$Internal$Style$classes.b4 + (' ~ s.' + mdgriffith$stylish_elephants$Internal$Style$classes.b2)),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-grow', '0')
									])),
								mdgriffith$stylish_elephants$Internal$Style$describeAlignment(
								function (alignment) {
									switch (alignment) {
										case 0:
											return _Utils_Tuple2(
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-items', 'flex-start')
													]),
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-self', 'flex-start')
													]));
										case 1:
											return _Utils_Tuple2(
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-items', 'flex-end')
													]),
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-self', 'flex-end')
													]));
										case 2:
											return _Utils_Tuple2(
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'justify-content', 'flex-end')
													]),
												_List_Nil);
										case 3:
											return _Utils_Tuple2(
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'justify-content', 'flex-start')
													]),
												_List_Nil);
										case 4:
											return _Utils_Tuple2(
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'justify-content', 'center')
													]),
												_List_Nil);
										default:
											return _Utils_Tuple2(
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-items', 'center')
													]),
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-self', 'center')
													]));
									}
								}),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Descriptor,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.c9),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'justify-content', 'space-between')
									]))
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.F),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'flex'),
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-direction', 'column'),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.aY),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-grow', '100000')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.a6),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'width', '100%')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.bX),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'width', '100%')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.a5),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-self', 'flex-start')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								'u:first-of-type.' + mdgriffith$stylish_elephants$Internal$Style$classes.b1,
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-grow', '1')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								's:first-of-type.' + mdgriffith$stylish_elephants$Internal$Style$classes.b3,
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-grow', '1'),
										A2(
										mdgriffith$stylish_elephants$Internal$Style$Child,
										mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b0),
										_List_fromArray(
											[
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin-top', 'auto !important'),
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin-bottom', '0 !important')
											]))
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								's:last-of-type.' + mdgriffith$stylish_elephants$Internal$Style$classes.b3,
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-grow', '1'),
										A2(
										mdgriffith$stylish_elephants$Internal$Style$Child,
										mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b0),
										_List_fromArray(
											[
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin-bottom', 'auto !important'),
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin-top', '0 !important')
											]))
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								's:only-of-type.' + mdgriffith$stylish_elephants$Internal$Style$classes.b3,
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-grow', '1'),
										A2(
										mdgriffith$stylish_elephants$Internal$Style$Child,
										mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b0),
										_List_fromArray(
											[
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin-top', 'auto !important'),
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin-bottom', 'auto !important')
											]))
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								's:last-of-type.' + (mdgriffith$stylish_elephants$Internal$Style$classes.b3 + ' ~ u'),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-grow', '0')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								'u:first-of-type.' + (mdgriffith$stylish_elephants$Internal$Style$classes.b1 + (' ~ s.' + mdgriffith$stylish_elephants$Internal$Style$classes.b3)),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-grow', '0')
									])),
								mdgriffith$stylish_elephants$Internal$Style$describeAlignment(
								function (alignment) {
									switch (alignment) {
										case 0:
											return _Utils_Tuple2(
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'justify-content', 'flex-start')
													]),
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin-bottom', 'auto')
													]));
										case 1:
											return _Utils_Tuple2(
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'justify-content', 'flex-end')
													]),
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin-top', 'auto')
													]));
										case 2:
											return _Utils_Tuple2(
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-items', 'flex-end')
													]),
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-self', 'flex-end')
													]));
										case 3:
											return _Utils_Tuple2(
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-items', 'flex-start')
													]),
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-self', 'flex-start')
													]));
										case 4:
											return _Utils_Tuple2(
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-items', 'center')
													]),
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-self', 'center')
													]));
										default:
											return _Utils_Tuple2(
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'justify-content', 'center')
													]),
												_List_Nil);
									}
								}),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.aD),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-grow', '0'),
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'flex-basis', 'auto'),
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'width', '100%'),
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-self', 'stretch !important')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Descriptor,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.c9),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'justify-content', 'space-between')
									]))
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cw),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', '-ms-grid'),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								'.gp',
								_List_fromArray(
									[
										A2(
										mdgriffith$stylish_elephants$Internal$Style$Child,
										mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b6),
										_List_fromArray(
											[
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'width', '100%')
											]))
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Supports,
								_Utils_Tuple2('display', 'grid'),
								_List_fromArray(
									[
										_Utils_Tuple2('display', 'grid')
									])),
								mdgriffith$stylish_elephants$Internal$Style$gridAlignments(
								function (alignment) {
									switch (alignment) {
										case 0:
											return _List_fromArray(
												[
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'justify-content', 'flex-start')
												]);
										case 1:
											return _List_fromArray(
												[
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'justify-content', 'flex-end')
												]);
										case 2:
											return _List_fromArray(
												[
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-items', 'flex-end')
												]);
										case 3:
											return _List_fromArray(
												[
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-items', 'flex-start')
												]);
										case 4:
											return _List_fromArray(
												[
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'align-items', 'center')
												]);
										default:
											return _List_fromArray(
												[
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'justify-content', 'center')
												]);
									}
								})
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.aq),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'block'),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b6 + ':first-child'),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin', '0 !important')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(
									mdgriffith$stylish_elephants$Internal$Style$classes.b6 + (mdgriffith$stylish_elephants$Internal$Style$selfName(3) + (':first-child + .' + mdgriffith$stylish_elephants$Internal$Style$classes.b6))),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin', '0 !important')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(
									mdgriffith$stylish_elephants$Internal$Style$classes.b6 + (mdgriffith$stylish_elephants$Internal$Style$selfName(2) + (':first-child + .' + mdgriffith$stylish_elephants$Internal$Style$classes.b6))),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin', '0 !important')
									])),
								mdgriffith$stylish_elephants$Internal$Style$describeAlignment(
								function (alignment) {
									switch (alignment) {
										case 0:
											return _Utils_Tuple2(_List_Nil, _List_Nil);
										case 1:
											return _Utils_Tuple2(_List_Nil, _List_Nil);
										case 2:
											return _Utils_Tuple2(
												_List_Nil,
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'float', 'right'),
														A2(
														mdgriffith$stylish_elephants$Internal$Style$Descriptor,
														':after:',
														_List_fromArray(
															[
																A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'content', '\"\"'),
																A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'table'),
																A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'clear', 'both')
															]))
													]));
										case 3:
											return _Utils_Tuple2(
												_List_Nil,
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'float', 'left'),
														A2(
														mdgriffith$stylish_elephants$Internal$Style$Descriptor,
														':after:',
														_List_fromArray(
															[
																A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'content', '\"\"'),
																A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'table'),
																A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'clear', 'both')
															]))
													]));
										case 4:
											return _Utils_Tuple2(_List_Nil, _List_Nil);
										default:
											return _Utils_Tuple2(_List_Nil, _List_Nil);
									}
								})
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cG),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'white-space', 'pre-wrap')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.bz),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'block'),
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'white-space', 'normal'),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Descriptor,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cx),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'z-index', '0'),
										A2(
										mdgriffith$stylish_elephants$Internal$Style$Child,
										mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b8),
										_List_fromArray(
											[
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'z-index', '-1')
											]))
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.q),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'inline'),
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'white-space', 'normal')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.c7),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'inline'),
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'white-space', 'normal'),
										A2(
										mdgriffith$stylish_elephants$Internal$Style$Descriptor,
										mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cE),
										_List_fromArray(
											[
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'flex')
											])),
										A2(
										mdgriffith$stylish_elephants$Internal$Style$Descriptor,
										mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b8),
										_List_fromArray(
											[
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'flex')
											])),
										A2(
										mdgriffith$stylish_elephants$Internal$Style$Descriptor,
										mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.bZ),
										_List_fromArray(
											[
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'flex')
											])),
										A2(
										mdgriffith$stylish_elephants$Internal$Style$Descriptor,
										mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b9),
										_List_fromArray(
											[
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'flex')
											])),
										A2(
										mdgriffith$stylish_elephants$Internal$Style$Descriptor,
										mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cT),
										_List_fromArray(
											[
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'flex')
											])),
										A2(
										mdgriffith$stylish_elephants$Internal$Style$Descriptor,
										mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cR),
										_List_fromArray(
											[
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'flex')
											])),
										A2(
										mdgriffith$stylish_elephants$Internal$Style$Child,
										mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.q),
										_List_fromArray(
											[
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'inline'),
												A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'white-space', 'normal')
											]))
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.L),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'inline-flex')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.F),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'inline-flex')
									])),
								A2(
								mdgriffith$stylish_elephants$Internal$Style$Child,
								mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cw),
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'inline-grid')
									])),
								mdgriffith$stylish_elephants$Internal$Style$describeAlignment(
								function (alignment) {
									switch (alignment) {
										case 0:
											return _Utils_Tuple2(_List_Nil, _List_Nil);
										case 1:
											return _Utils_Tuple2(_List_Nil, _List_Nil);
										case 2:
											return _Utils_Tuple2(
												_List_Nil,
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'float', 'right')
													]));
										case 3:
											return _Utils_Tuple2(
												_List_Nil,
												_List_fromArray(
													[
														A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'float', 'left')
													]));
										case 4:
											return _Utils_Tuple2(_List_Nil, _List_Nil);
										default:
											return _Utils_Tuple2(_List_Nil, _List_Nil);
									}
								})
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						'.hidden',
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'display', 'none')
							])),
						mdgriffith$stylish_elephants$Internal$Style$Batch(
						function (fn) {
							return A2(elm$core$List$map, fn, mdgriffith$stylish_elephants$Internal$Style$locations);
						}(
							function (loc) {
								switch (loc) {
									case 0:
										return A2(
											mdgriffith$stylish_elephants$Internal$Style$Descriptor,
											mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.bZ),
											_List_fromArray(
												[
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'position', 'absolute'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'bottom', '100%'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'left', '0'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'width', '100%'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'z-index', '10'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin', '0 !important'),
													A2(
													mdgriffith$stylish_elephants$Internal$Style$Child,
													mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.aY),
													_List_fromArray(
														[
															A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'height', 'auto')
														])),
													A2(
													mdgriffith$stylish_elephants$Internal$Style$Child,
													mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.a6),
													_List_fromArray(
														[
															A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'width', '100%')
														])),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'pointer-events', 'none'),
													A2(
													mdgriffith$stylish_elephants$Internal$Style$Child,
													mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b6),
													_List_fromArray(
														[
															A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'pointer-events', 'auto')
														]))
												]));
									case 1:
										return A2(
											mdgriffith$stylish_elephants$Internal$Style$Descriptor,
											mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b9),
											_List_fromArray(
												[
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'position', 'absolute'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'bottom', '0'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'left', '0'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'height', '0'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'width', '100%'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'z-index', '10'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin', '0 !important'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'pointer-events', 'auto'),
													A2(
													mdgriffith$stylish_elephants$Internal$Style$Child,
													mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.aY),
													_List_fromArray(
														[
															A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'height', 'auto')
														]))
												]));
									case 2:
										return A2(
											mdgriffith$stylish_elephants$Internal$Style$Descriptor,
											mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cT),
											_List_fromArray(
												[
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'position', 'absolute'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'left', '100%'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'top', '0'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'height', '100%'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin', '0 !important'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'z-index', '10'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'pointer-events', 'auto')
												]));
									case 3:
										return A2(
											mdgriffith$stylish_elephants$Internal$Style$Descriptor,
											mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cR),
											_List_fromArray(
												[
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'position', 'absolute'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'right', '100%'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'top', '0'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'height', '100%'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin', '0 !important'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'z-index', '10'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'pointer-events', 'auto')
												]));
									case 4:
										return A2(
											mdgriffith$stylish_elephants$Internal$Style$Descriptor,
											mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cE),
											_List_fromArray(
												[
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'position', 'absolute'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'width', '100%'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'height', '100%'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'left', '0'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'top', '0'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin', '0 !important'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'z-index', '10'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'pointer-events', 'none'),
													A2(
													mdgriffith$stylish_elephants$Internal$Style$Child,
													mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b6),
													_List_fromArray(
														[
															A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'pointer-events', 'auto')
														]))
												]));
									default:
										return A2(
											mdgriffith$stylish_elephants$Internal$Style$Descriptor,
											mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b8),
											_List_fromArray(
												[
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'position', 'absolute'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'width', '100%'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'height', '100%'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'left', '0'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'top', '0'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'margin', '0 !important'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'z-index', '0'),
													A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'pointer-events', 'none'),
													A2(
													mdgriffith$stylish_elephants$Internal$Style$Child,
													mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.b6),
													_List_fromArray(
														[
															A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'pointer-events', 'auto')
														]))
												]));
								}
							})),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.dr),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'font-weight', '100')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.di),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'font-weight', '200')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.dm),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'font-weight', '300')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.$7),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'font-weight', '400')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.dn),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'font-weight', '500')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.dq),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'font-weight', '600')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.bb),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'font-weight', '700')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.dh),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'font-weight', '800')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.dj),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'font-weight', '900')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.cJ),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'font-style', 'italic')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.dd),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'text-decoration', 'line-through')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.dw),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'text-decoration', 'underline'),
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'text-decoration-skip-ink', 'auto'),
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'text-decoration-skip', 'ink')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.ds),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'font-style', 'normal')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.dk),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'text-align', 'justify')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.aO),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'text-align', 'justify-all')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.dg),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'text-align', 'center')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.dp),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'text-align', 'right')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						mdgriffith$stylish_elephants$Internal$Style$dot(mdgriffith$stylish_elephants$Internal$Style$classes.dl),
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'text-align', 'left')
							])),
						A2(
						mdgriffith$stylish_elephants$Internal$Style$Descriptor,
						'.modal',
						_List_fromArray(
							[
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'position', 'fixed'),
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'left', '0'),
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'top', '0'),
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'width', '100%'),
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'height', '100%'),
								A2(mdgriffith$stylish_elephants$Internal$Style$Prop, 'pointer-events', 'none')
							]))
					]))
			])));
var mdgriffith$stylish_elephants$Internal$Model$staticRoot = A3(
	elm$virtual_dom$VirtualDom$node,
	'style',
	_List_Nil,
	_List_fromArray(
		[
			elm$virtual_dom$VirtualDom$text(mdgriffith$stylish_elephants$Internal$Style$rules)
		]));
var mdgriffith$stylish_elephants$Internal$Model$renderFont = function (families) {
	var fontName = function (font) {
		switch (font.$) {
			case 0:
				return 'serif';
			case 1:
				return 'sans-serif';
			case 2:
				return 'monospace';
			case 3:
				var name = font.a;
				return '\"' + (name + '\"');
			default:
				var name = font.a;
				var url = font.b;
				return '\"' + (name + '\"');
		}
	};
	return A2(
		elm$core$String$join,
		', ',
		A2(elm$core$List$map, fontName, families));
};
var mdgriffith$stylish_elephants$Internal$Model$transformValue = function (transform) {
	switch (transform.$) {
		case 0:
			return elm$core$Maybe$Nothing;
		case 1:
			var _n1 = transform.a;
			var x = _n1.a;
			var y = _n1.b;
			var z = _n1.c;
			return elm$core$Maybe$Just(
				'translate3d(' + (elm$core$String$fromFloat(x) + ('px, ' + (elm$core$String$fromFloat(y) + ('px, ' + (elm$core$String$fromFloat(z) + 'px)'))))));
		default:
			var _n2 = transform.a;
			var tx = _n2.a;
			var ty = _n2.b;
			var tz = _n2.c;
			var _n3 = transform.b;
			var sx = _n3.a;
			var sy = _n3.b;
			var sz = _n3.c;
			var _n4 = transform.c;
			var ox = _n4.a;
			var oy = _n4.b;
			var oz = _n4.c;
			var angle = transform.d;
			var translate = 'translate3d(' + (elm$core$String$fromFloat(tx) + ('px, ' + (elm$core$String$fromFloat(ty) + ('px, ' + (elm$core$String$fromFloat(tz) + 'px)')))));
			var scale = 'scale3d(' + (elm$core$String$fromFloat(sx) + (', ' + (elm$core$String$fromFloat(sy) + (', ' + (elm$core$String$fromFloat(sz) + ')')))));
			var rotate = 'rotate3d(' + (elm$core$String$fromFloat(ox) + (', ' + (elm$core$String$fromFloat(oy) + (', ' + (elm$core$String$fromFloat(oz) + (', ' + (elm$core$String$fromFloat(angle) + 'rad)')))))));
			return elm$core$Maybe$Just(translate + (' ' + (scale + (' ' + rotate))));
	}
};
var mdgriffith$stylish_elephants$Internal$Model$toStyleSheetString = F2(
	function (options, stylesheet) {
		var renderTopLevels = function (rule) {
			if (rule.$ === 1) {
				var name = rule.a;
				var typefaces = rule.b;
				var getImports = function (font) {
					if (font.$ === 4) {
						var url = font.b;
						return elm$core$Maybe$Just('@import url(\'' + (url + '\');'));
					} else {
						return elm$core$Maybe$Nothing;
					}
				};
				return elm$core$Maybe$Just(
					A2(
						elm$core$String$join,
						'\n',
						A2(elm$core$List$filterMap, getImports, typefaces)));
			} else {
				return elm$core$Maybe$Nothing;
			}
		};
		var renderProps = F3(
			function (force, _n18, existing) {
				var key = _n18.a;
				var val = _n18.b;
				return force ? (existing + ('\n  ' + (key + (': ' + (val + ' !important;'))))) : (existing + ('\n  ' + (key + (': ' + (val + ';')))));
			});
		var renderStyle = F3(
			function (maybePseudo, selector, props) {
				if (maybePseudo.$ === 1) {
					return selector + ('{' + (A3(
						elm$core$List$foldl,
						renderProps(false),
						'',
						props) + '\n}'));
				} else {
					var pseudo = maybePseudo.a;
					switch (pseudo) {
						case 1:
							var _n17 = options.cA;
							switch (_n17) {
								case 0:
									return '';
								case 2:
									return selector + ('-hv {' + (A3(
										elm$core$List$foldl,
										renderProps(true),
										'',
										props) + '\n}'));
								default:
									return selector + ('-hv:hover {' + (A3(
										elm$core$List$foldl,
										renderProps(false),
										'',
										props) + '\n}'));
							}
						case 0:
							var renderedProps = A3(
								elm$core$List$foldl,
								renderProps(false),
								'',
								props);
							return A2(
								elm$core$String$join,
								'\n',
								_List_fromArray(
									[selector + ('-fs:focus {' + (renderedProps + '\n}')), '.se:focus ~ ' + (selector + ('-fs:not(.focus)  {' + (renderedProps + '\n}'))), '.se:focus ' + (selector + ('-fs  {' + (renderedProps + '\n}')))]));
						default:
							return selector + ('-act:active {' + (A3(
								elm$core$List$foldl,
								renderProps(false),
								'',
								props) + '\n}'));
					}
				}
			});
		var renderStyleRule = F2(
			function (rule, maybePseudo) {
				switch (rule.$) {
					case 0:
						var selector = rule.a;
						var props = rule.b;
						return A3(renderStyle, maybePseudo, selector, props);
					case 12:
						var name = rule.a;
						var prop = rule.b;
						return A3(
							renderStyle,
							maybePseudo,
							'.' + name,
							_List_fromArray(
								[
									A2(mdgriffith$stylish_elephants$Internal$Model$Property, 'box-shadow', prop)
								]));
					case 11:
						var name = rule.a;
						var transparency = rule.b;
						var opacity = A2(
							elm$core$Basics$max,
							0,
							A2(elm$core$Basics$min, 1, 1 - transparency));
						return A3(
							renderStyle,
							maybePseudo,
							'.' + name,
							_List_fromArray(
								[
									A2(
									mdgriffith$stylish_elephants$Internal$Model$Property,
									'opacity',
									elm$core$String$fromFloat(opacity))
								]));
					case 2:
						var i = rule.a;
						return A3(
							renderStyle,
							maybePseudo,
							'.font-size-' + elm$core$String$fromInt(i),
							_List_fromArray(
								[
									A2(
									mdgriffith$stylish_elephants$Internal$Model$Property,
									'font-size',
									elm$core$String$fromInt(i) + 'px')
								]));
					case 1:
						var name = rule.a;
						var typefaces = rule.b;
						return A3(
							renderStyle,
							maybePseudo,
							'.' + name,
							_List_fromArray(
								[
									A2(
									mdgriffith$stylish_elephants$Internal$Model$Property,
									'font-family',
									mdgriffith$stylish_elephants$Internal$Model$renderFont(typefaces))
								]));
					case 3:
						var _class = rule.a;
						var prop = rule.b;
						var val = rule.c;
						return A3(
							renderStyle,
							maybePseudo,
							'.' + _class,
							_List_fromArray(
								[
									A2(mdgriffith$stylish_elephants$Internal$Model$Property, prop, val)
								]));
					case 4:
						var _class = rule.a;
						var prop = rule.b;
						var color = rule.c;
						return A3(
							renderStyle,
							maybePseudo,
							'.' + _class,
							_List_fromArray(
								[
									A2(
									mdgriffith$stylish_elephants$Internal$Model$Property,
									prop,
									mdgriffith$stylish_elephants$Internal$Model$formatColor(color))
								]));
					case 5:
						var cls = rule.a;
						var x = rule.b;
						var y = rule.c;
						var yPx = elm$core$String$fromInt(y) + 'px';
						var xPx = elm$core$String$fromInt(x) + 'px';
						var row = '.' + function ($) {
							return $.L;
						}(mdgriffith$stylish_elephants$Internal$Style$classes);
						var right = '.' + function ($) {
							return $.a9;
						}(mdgriffith$stylish_elephants$Internal$Style$classes);
						var paragraph = '.' + function ($) {
							return $.bz;
						}(mdgriffith$stylish_elephants$Internal$Style$classes);
						var page = '.' + function ($) {
							return $.aq;
						}(mdgriffith$stylish_elephants$Internal$Style$classes);
						var left = '.' + function ($) {
							return $.a8;
						}(mdgriffith$stylish_elephants$Internal$Style$classes);
						var column = '.' + function ($) {
							return $.F;
						}(mdgriffith$stylish_elephants$Internal$Style$classes);
						var _class = '.' + cls;
						var any = '.' + function ($) {
							return $.b6;
						}(mdgriffith$stylish_elephants$Internal$Style$classes);
						return A3(
							elm$core$List$foldl,
							elm$core$Basics$append,
							'',
							_List_fromArray(
								[
									A3(
									renderStyle,
									maybePseudo,
									_class + (row + (' > ' + (any + (' + ' + any)))),
									_List_fromArray(
										[
											A2(mdgriffith$stylish_elephants$Internal$Model$Property, 'margin-left', xPx)
										])),
									A3(
									renderStyle,
									maybePseudo,
									_class + (column + (' > ' + (any + (' + ' + any)))),
									_List_fromArray(
										[
											A2(mdgriffith$stylish_elephants$Internal$Model$Property, 'margin-top', yPx)
										])),
									A3(
									renderStyle,
									maybePseudo,
									_class + (page + (' > ' + (any + (' + ' + any)))),
									_List_fromArray(
										[
											A2(mdgriffith$stylish_elephants$Internal$Model$Property, 'margin-top', yPx)
										])),
									A3(
									renderStyle,
									maybePseudo,
									_class + (page + (' > ' + left)),
									_List_fromArray(
										[
											A2(mdgriffith$stylish_elephants$Internal$Model$Property, 'margin-right', xPx)
										])),
									A3(
									renderStyle,
									maybePseudo,
									_class + (page + (' > ' + right)),
									_List_fromArray(
										[
											A2(mdgriffith$stylish_elephants$Internal$Model$Property, 'margin-left', xPx)
										])),
									A3(
									renderStyle,
									maybePseudo,
									_Utils_ap(_class, paragraph),
									_List_fromArray(
										[
											A2(
											mdgriffith$stylish_elephants$Internal$Model$Property,
											'line-height',
											'calc(1em + ' + (elm$core$String$fromInt(y) + 'px)'))
										])),
									A3(
									renderStyle,
									maybePseudo,
									'textarea' + _class,
									_List_fromArray(
										[
											A2(
											mdgriffith$stylish_elephants$Internal$Model$Property,
											'line-height',
											'calc(1em + ' + (elm$core$String$fromInt(y) + 'px)'))
										])),
									A3(
									renderStyle,
									maybePseudo,
									_class + (paragraph + (' > ' + left)),
									_List_fromArray(
										[
											A2(mdgriffith$stylish_elephants$Internal$Model$Property, 'margin-right', xPx)
										])),
									A3(
									renderStyle,
									maybePseudo,
									_class + (paragraph + (' > ' + right)),
									_List_fromArray(
										[
											A2(mdgriffith$stylish_elephants$Internal$Model$Property, 'margin-left', xPx)
										])),
									A3(
									renderStyle,
									maybePseudo,
									_class + (paragraph + '::after'),
									_List_fromArray(
										[
											A2(mdgriffith$stylish_elephants$Internal$Model$Property, 'content', '\'\''),
											A2(mdgriffith$stylish_elephants$Internal$Model$Property, 'display', 'block'),
											A2(mdgriffith$stylish_elephants$Internal$Model$Property, 'height', '0'),
											A2(mdgriffith$stylish_elephants$Internal$Model$Property, 'width', '0'),
											A2(
											mdgriffith$stylish_elephants$Internal$Model$Property,
											'margin-top',
											elm$core$String$fromInt((-1) * ((y / 2) | 0)) + 'px')
										])),
									A3(
									renderStyle,
									maybePseudo,
									_class + (paragraph + '::before'),
									_List_fromArray(
										[
											A2(mdgriffith$stylish_elephants$Internal$Model$Property, 'content', '\'\''),
											A2(mdgriffith$stylish_elephants$Internal$Model$Property, 'display', 'block'),
											A2(mdgriffith$stylish_elephants$Internal$Model$Property, 'height', '0'),
											A2(mdgriffith$stylish_elephants$Internal$Model$Property, 'width', '0'),
											A2(
											mdgriffith$stylish_elephants$Internal$Model$Property,
											'margin-bottom',
											elm$core$String$fromInt((-1) * ((y / 2) | 0)) + 'px')
										]))
								]));
					case 6:
						var cls = rule.a;
						var top = rule.b;
						var right = rule.c;
						var bottom = rule.d;
						var left = rule.e;
						var _class = '.' + cls;
						return A3(
							renderStyle,
							maybePseudo,
							_class,
							_List_fromArray(
								[
									A2(
									mdgriffith$stylish_elephants$Internal$Model$Property,
									'padding',
									elm$core$String$fromInt(top) + ('px ' + (elm$core$String$fromInt(right) + ('px ' + (elm$core$String$fromInt(bottom) + ('px ' + (elm$core$String$fromInt(left) + 'px')))))))
								]));
					case 7:
						var template = rule.a;
						var toGridLengthHelper = F3(
							function (minimum, maximum, x) {
								switch (x.$) {
									case 0:
										var px = x.a;
										return elm$core$String$fromInt(px) + 'px';
									case 1:
										var _n2 = _Utils_Tuple2(minimum, maximum);
										if (_n2.a.$ === 1) {
											if (_n2.b.$ === 1) {
												var _n3 = _n2.a;
												var _n4 = _n2.b;
												return 'max-content';
											} else {
												var _n6 = _n2.a;
												var maxSize = _n2.b.a;
												return 'minmax(max-content, ' + (elm$core$String$fromInt(maxSize) + 'px)');
											}
										} else {
											if (_n2.b.$ === 1) {
												var minSize = _n2.a.a;
												var _n5 = _n2.b;
												return 'minmax(' + (elm$core$String$fromInt(minSize) + ('px, ' + 'max-content)'));
											} else {
												var minSize = _n2.a.a;
												var maxSize = _n2.b.a;
												return 'minmax(' + (elm$core$String$fromInt(minSize) + ('px, ' + (elm$core$String$fromInt(maxSize) + 'px)')));
											}
										}
									case 2:
										var i = x.a;
										var _n7 = _Utils_Tuple2(minimum, maximum);
										if (_n7.a.$ === 1) {
											if (_n7.b.$ === 1) {
												var _n8 = _n7.a;
												var _n9 = _n7.b;
												return elm$core$String$fromInt(i) + 'fr';
											} else {
												var _n11 = _n7.a;
												var maxSize = _n7.b.a;
												return 'minmax(max-content, ' + (elm$core$String$fromInt(maxSize) + 'px)');
											}
										} else {
											if (_n7.b.$ === 1) {
												var minSize = _n7.a.a;
												var _n10 = _n7.b;
												return 'minmax(' + (elm$core$String$fromInt(minSize) + ('px, ' + (elm$core$String$fromInt(i) + ('fr' + 'fr)'))));
											} else {
												var minSize = _n7.a.a;
												var maxSize = _n7.b.a;
												return 'minmax(' + (elm$core$String$fromInt(minSize) + ('px, ' + (elm$core$String$fromInt(maxSize) + 'px)')));
											}
										}
									case 3:
										var m = x.a;
										var len = x.b;
										return A3(
											toGridLengthHelper,
											elm$core$Maybe$Just(m),
											maximum,
											len);
									default:
										var m = x.a;
										var len = x.b;
										return A3(
											toGridLengthHelper,
											minimum,
											elm$core$Maybe$Just(m),
											len);
								}
							});
						var toGridLength = function (x) {
							return A3(toGridLengthHelper, elm$core$Maybe$Nothing, elm$core$Maybe$Nothing, x);
						};
						var xSpacing = toGridLength(template.da.a);
						var ySpacing = toGridLength(template.da.b);
						var rows = function (x) {
							return 'grid-template-rows: ' + (x + ';');
						}(
							A2(
								elm$core$String$join,
								' ',
								A2(elm$core$List$map, toGridLength, template.c1)));
						var msRows = function (x) {
							return '-ms-grid-rows: ' + (x + ';');
						}(
							A2(
								elm$core$String$join,
								ySpacing,
								A2(elm$core$List$map, toGridLength, template.o)));
						var msColumns = function (x) {
							return '-ms-grid-columns: ' + (x + ';');
						}(
							A2(
								elm$core$String$join,
								ySpacing,
								A2(elm$core$List$map, toGridLength, template.o)));
						var gapY = 'grid-row-gap:' + (toGridLength(template.da.b) + ';');
						var gapX = 'grid-column-gap:' + (toGridLength(template.da.a) + ';');
						var columns = function (x) {
							return 'grid-template-columns: ' + (x + ';');
						}(
							A2(
								elm$core$String$join,
								' ',
								A2(elm$core$List$map, toGridLength, template.o)));
						var _class = '.grid-rows-' + (A2(
							elm$core$String$join,
							'-',
							A2(elm$core$List$map, mdgriffith$stylish_elephants$Internal$Model$lengthClassName, template.c1)) + ('-cols-' + (A2(
							elm$core$String$join,
							'-',
							A2(elm$core$List$map, mdgriffith$stylish_elephants$Internal$Model$lengthClassName, template.o)) + ('-space-x-' + (mdgriffith$stylish_elephants$Internal$Model$lengthClassName(template.da.a) + ('-space-y-' + mdgriffith$stylish_elephants$Internal$Model$lengthClassName(template.da.b)))))));
						var modernGrid = _class + ('{' + (columns + (rows + (gapX + (gapY + '}')))));
						var supports = '@supports (display:grid) {' + (modernGrid + '}');
						var base = _class + ('{' + (msColumns + (msRows + '}')));
						return _Utils_ap(base, supports);
					case 8:
						var position = rule.a;
						var msPosition = A2(
							elm$core$String$join,
							' ',
							_List_fromArray(
								[
									'-ms-grid-row: ' + (elm$core$String$fromInt(position.L) + ';'),
									'-ms-grid-row-span: ' + (elm$core$String$fromInt(position.G) + ';'),
									'-ms-grid-column: ' + (elm$core$String$fromInt(position.cl) + ';'),
									'-ms-grid-column-span: ' + (elm$core$String$fromInt(position.D) + ';')
								]));
						var modernPosition = A2(
							elm$core$String$join,
							' ',
							_List_fromArray(
								[
									'grid-row: ' + (elm$core$String$fromInt(position.L) + (' / ' + (elm$core$String$fromInt(position.L + position.G) + ';'))),
									'grid-column: ' + (elm$core$String$fromInt(position.cl) + (' / ' + (elm$core$String$fromInt(position.cl + position.D) + ';')))
								]));
						var _class = '.grid-pos-' + (elm$core$String$fromInt(position.L) + ('-' + (elm$core$String$fromInt(position.cl) + ('-' + (elm$core$String$fromInt(position.D) + ('-' + elm$core$String$fromInt(position.G)))))));
						var modernGrid = _class + ('{' + (modernPosition + '}'));
						var supports = '@supports (display:grid) {' + (modernGrid + '}');
						var base = _class + ('{' + (msPosition + '}'));
						return _Utils_ap(base, supports);
					case 10:
						var _class = rule.a;
						var styles = rule.b;
						var renderPseudoRule = function (style) {
							return A2(
								renderStyleRule,
								style,
								elm$core$Maybe$Just(_class));
						};
						return A2(
							elm$core$String$join,
							' ',
							A2(elm$core$List$map, renderPseudoRule, styles));
					default:
						var transform = rule.a;
						var val = mdgriffith$stylish_elephants$Internal$Model$transformValue(transform);
						var _class = mdgriffith$stylish_elephants$Internal$Model$transformClass(transform);
						var _n12 = _Utils_Tuple2(_class, val);
						if ((!_n12.a.$) && (!_n12.b.$)) {
							var cls = _n12.a.a;
							var v = _n12.b.a;
							return A3(
								renderStyle,
								maybePseudo,
								'.' + cls,
								_List_fromArray(
									[
										A2(mdgriffith$stylish_elephants$Internal$Model$Property, 'transform', v)
									]));
						} else {
							return '';
						}
				}
			});
		var combine = F2(
			function (style, rendered) {
				return _Utils_update(
					rendered,
					{
						aL: _Utils_ap(
							rendered.aL,
							A2(renderStyleRule, style, elm$core$Maybe$Nothing)),
						av: function () {
							var _n14 = renderTopLevels(style);
							if (_n14.$ === 1) {
								return rendered.av;
							} else {
								var topLevel = _n14.a;
								return _Utils_ap(rendered.av, topLevel);
							}
						}()
					});
			});
		var _n13 = A3(
			elm$core$List$foldl,
			combine,
			{aL: '', av: ''},
			stylesheet);
		var topLevel = _n13.av;
		var rules = _n13.aL;
		return _Utils_ap(topLevel, rules);
	});
var mdgriffith$stylish_elephants$Internal$Model$toStyleSheet = F2(
	function (options, styleSheet) {
		return A3(
			elm$virtual_dom$VirtualDom$node,
			'style',
			_List_Nil,
			_List_fromArray(
				[
					elm$virtual_dom$VirtualDom$text(
					A2(mdgriffith$stylish_elephants$Internal$Model$toStyleSheetString, options, styleSheet))
				]));
	});
var mdgriffith$stylish_elephants$Internal$Model$embedKeyed = F4(
	function (_static, opts, styles, children) {
		return _static ? A2(
			elm$core$List$cons,
			_Utils_Tuple2('static-stylesheet', mdgriffith$stylish_elephants$Internal$Model$staticRoot),
			A2(
				elm$core$List$cons,
				_Utils_Tuple2(
					'dynamic-stylesheet',
					A2(
						mdgriffith$stylish_elephants$Internal$Model$toStyleSheet,
						opts,
						A3(
							elm$core$List$foldl,
							mdgriffith$stylish_elephants$Internal$Model$reduceStyles,
							_Utils_Tuple2(
								elm$core$Set$empty,
								_List_fromArray(
									[
										mdgriffith$stylish_elephants$Internal$Model$renderFocusStyle(opts.cv)
									])),
							styles).b)),
				children)) : A2(
			elm$core$List$cons,
			_Utils_Tuple2(
				'dynamic-stylesheet',
				A2(
					mdgriffith$stylish_elephants$Internal$Model$toStyleSheet,
					opts,
					A3(
						elm$core$List$foldl,
						mdgriffith$stylish_elephants$Internal$Model$reduceStyles,
						_Utils_Tuple2(
							elm$core$Set$empty,
							_List_fromArray(
								[
									mdgriffith$stylish_elephants$Internal$Model$renderFocusStyle(opts.cv)
								])),
						styles).b)),
			children);
	});
var mdgriffith$stylish_elephants$Internal$Model$embedWith = F4(
	function (_static, opts, styles, children) {
		return _static ? A2(
			elm$core$List$cons,
			mdgriffith$stylish_elephants$Internal$Model$staticRoot,
			A2(
				elm$core$List$cons,
				A2(
					mdgriffith$stylish_elephants$Internal$Model$toStyleSheet,
					opts,
					A3(
						elm$core$List$foldl,
						mdgriffith$stylish_elephants$Internal$Model$reduceStyles,
						_Utils_Tuple2(
							elm$core$Set$empty,
							_List_fromArray(
								[
									mdgriffith$stylish_elephants$Internal$Model$renderFocusStyle(opts.cv)
								])),
						styles).b),
				children)) : A2(
			elm$core$List$cons,
			A2(
				mdgriffith$stylish_elephants$Internal$Model$toStyleSheet,
				opts,
				A3(
					elm$core$List$foldl,
					mdgriffith$stylish_elephants$Internal$Model$reduceStyles,
					_Utils_Tuple2(
						elm$core$Set$empty,
						_List_fromArray(
							[
								mdgriffith$stylish_elephants$Internal$Model$renderFocusStyle(opts.cv)
							])),
					styles).b),
			children);
	});
var mdgriffith$stylish_elephants$Internal$Model$finalizeNode = F6(
	function (has, node, attributes, children, embedMode, parentContext) {
		var createNode = F2(
			function (nodeName, attrs) {
				if (children.$ === 1) {
					var keyed = children.a;
					return A3(
						elm$virtual_dom$VirtualDom$keyedNode,
						nodeName,
						attrs,
						function () {
							switch (embedMode.$) {
								case 0:
									return keyed;
								case 2:
									var opts = embedMode.a;
									var styles = embedMode.b;
									return A4(mdgriffith$stylish_elephants$Internal$Model$embedKeyed, false, opts, styles, keyed);
								default:
									var opts = embedMode.a;
									var styles = embedMode.b;
									return A4(mdgriffith$stylish_elephants$Internal$Model$embedKeyed, true, opts, styles, keyed);
							}
						}());
				} else {
					var unkeyed = children.a;
					return A2(
						function () {
							switch (nodeName) {
								case 'div':
									return elm$html$Html$div;
								case 'p':
									return elm$html$Html$p;
								default:
									return elm$virtual_dom$VirtualDom$node(nodeName);
							}
						}(),
						attrs,
						function () {
							switch (embedMode.$) {
								case 0:
									return unkeyed;
								case 2:
									var opts = embedMode.a;
									var styles = embedMode.b;
									return A4(mdgriffith$stylish_elephants$Internal$Model$embedWith, false, opts, styles, unkeyed);
								default:
									var opts = embedMode.a;
									var styles = embedMode.b;
									return A4(mdgriffith$stylish_elephants$Internal$Model$embedWith, true, opts, styles, unkeyed);
							}
						}());
				}
			});
		var html = function () {
			switch (node.$) {
				case 0:
					return A2(createNode, 'div', attributes);
				case 1:
					var nodeName = node.a;
					return A2(createNode, nodeName, attributes);
				default:
					var nodeName = node.a;
					var internal = node.b;
					return A3(
						elm$virtual_dom$VirtualDom$node,
						nodeName,
						attributes,
						_List_fromArray(
							[
								A2(
								createNode,
								internal,
								_List_fromArray(
									[
										elm$html$Html$Attributes$class(mdgriffith$stylish_elephants$Internal$Style$classes.b6 + (' ' + mdgriffith$stylish_elephants$Internal$Style$classes.c7))
									]))
							]));
			}
		}();
		switch (parentContext) {
			case 0:
				return (A2(mdgriffith$stylish_elephants$Internal$Flag$present, mdgriffith$stylish_elephants$Internal$Flag$widthFill, has) && (!A2(mdgriffith$stylish_elephants$Internal$Flag$present, mdgriffith$stylish_elephants$Internal$Flag$widthBetween, has))) ? html : (A2(mdgriffith$stylish_elephants$Internal$Flag$present, mdgriffith$stylish_elephants$Internal$Flag$alignRight, has) ? A2(
					elm$html$Html$u,
					_List_fromArray(
						[
							elm$html$Html$Attributes$class(
							A2(
								elm$core$String$join,
								' ',
								_List_fromArray(
									[mdgriffith$stylish_elephants$Internal$Style$classes.b6, mdgriffith$stylish_elephants$Internal$Style$classes.c7, mdgriffith$stylish_elephants$Internal$Style$classes.aD, mdgriffith$stylish_elephants$Internal$Style$classes.ai, mdgriffith$stylish_elephants$Internal$Style$classes.b4])))
						]),
					_List_fromArray(
						[html])) : (A2(mdgriffith$stylish_elephants$Internal$Flag$present, mdgriffith$stylish_elephants$Internal$Flag$centerX, has) ? A2(
					elm$html$Html$s,
					_List_fromArray(
						[
							elm$html$Html$Attributes$class(
							A2(
								elm$core$String$join,
								' ',
								_List_fromArray(
									[mdgriffith$stylish_elephants$Internal$Style$classes.b6, mdgriffith$stylish_elephants$Internal$Style$classes.c7, mdgriffith$stylish_elephants$Internal$Style$classes.aD, mdgriffith$stylish_elephants$Internal$Style$classes.ai, mdgriffith$stylish_elephants$Internal$Style$classes.b2])))
						]),
					_List_fromArray(
						[html])) : html));
			case 1:
				return (A2(mdgriffith$stylish_elephants$Internal$Flag$present, mdgriffith$stylish_elephants$Internal$Flag$heightFill, has) && (!A2(mdgriffith$stylish_elephants$Internal$Flag$present, mdgriffith$stylish_elephants$Internal$Flag$heightBetween, has))) ? html : (A2(mdgriffith$stylish_elephants$Internal$Flag$present, mdgriffith$stylish_elephants$Internal$Flag$centerY, has) ? A2(
					elm$html$Html$s,
					_List_fromArray(
						[
							elm$html$Html$Attributes$class(
							A2(
								elm$core$String$join,
								' ',
								_List_fromArray(
									[mdgriffith$stylish_elephants$Internal$Style$classes.b6, mdgriffith$stylish_elephants$Internal$Style$classes.c7, mdgriffith$stylish_elephants$Internal$Style$classes.aD, mdgriffith$stylish_elephants$Internal$Style$classes.b3])))
						]),
					_List_fromArray(
						[html])) : (A2(mdgriffith$stylish_elephants$Internal$Flag$present, mdgriffith$stylish_elephants$Internal$Flag$alignBottom, has) ? A2(
					elm$html$Html$u,
					_List_fromArray(
						[
							elm$html$Html$Attributes$class(
							A2(
								elm$core$String$join,
								' ',
								_List_fromArray(
									[mdgriffith$stylish_elephants$Internal$Style$classes.b6, mdgriffith$stylish_elephants$Internal$Style$classes.c7, mdgriffith$stylish_elephants$Internal$Style$classes.aD, mdgriffith$stylish_elephants$Internal$Style$classes.b1])))
						]),
					_List_fromArray(
						[html])) : html));
			default:
				return html;
		}
	});
var mdgriffith$stylish_elephants$Internal$Model$space = elm$virtual_dom$VirtualDom$text(' ');
var elm$html$Html$text = elm$virtual_dom$VirtualDom$text;
var mdgriffith$stylish_elephants$Internal$Model$textElement = function (str) {
	return A2(
		elm$html$Html$div,
		_List_fromArray(
			[
				elm$html$Html$Attributes$class(
				A2(
					elm$core$String$join,
					' ',
					_List_fromArray(
						[mdgriffith$stylish_elephants$Internal$Style$classes.b6, mdgriffith$stylish_elephants$Internal$Style$classes.q, mdgriffith$stylish_elephants$Internal$Style$classes.a5, mdgriffith$stylish_elephants$Internal$Style$classes.ao])))
			]),
		_List_fromArray(
			[
				elm$html$Html$text(str)
			]));
};
var mdgriffith$stylish_elephants$Internal$Model$createElement = F3(
	function (context, children, rendered) {
		var gatherKeyed = F2(
			function (_n8, _n9) {
				var key = _n8.a;
				var child = _n8.b;
				var htmls = _n9.a;
				var existingStyles = _n9.b;
				switch (child.$) {
					case 0:
						var html = child.a;
						return _Utils_eq(context, mdgriffith$stylish_elephants$Internal$Model$asParagraph) ? _Utils_Tuple2(
							A2(
								elm$core$List$cons,
								_Utils_Tuple2(
									key,
									html(context)),
								A2(
									elm$core$List$cons,
									_Utils_Tuple2('sp', mdgriffith$stylish_elephants$Internal$Model$space),
									htmls)),
							existingStyles) : _Utils_Tuple2(
							A2(
								elm$core$List$cons,
								_Utils_Tuple2(
									key,
									html(context)),
								htmls),
							existingStyles);
					case 1:
						var styled = child.a;
						return _Utils_eq(context, mdgriffith$stylish_elephants$Internal$Model$asParagraph) ? _Utils_Tuple2(
							A2(
								elm$core$List$cons,
								_Utils_Tuple2(
									key,
									A2(styled.cB, mdgriffith$stylish_elephants$Internal$Model$NoStyleSheet, context)),
								A2(
									elm$core$List$cons,
									_Utils_Tuple2('sp', mdgriffith$stylish_elephants$Internal$Model$space),
									htmls)),
							_Utils_ap(styled.M, existingStyles)) : _Utils_Tuple2(
							A2(
								elm$core$List$cons,
								_Utils_Tuple2(
									key,
									A2(styled.cB, mdgriffith$stylish_elephants$Internal$Model$NoStyleSheet, context)),
								htmls),
							_Utils_ap(styled.M, existingStyles));
					case 2:
						var str = child.a;
						return (_Utils_eq(context, mdgriffith$stylish_elephants$Internal$Model$asEl) || _Utils_eq(context, mdgriffith$stylish_elephants$Internal$Model$asParagraph)) ? _Utils_Tuple2(
							A2(
								elm$core$List$cons,
								_Utils_Tuple2(
									key,
									elm$virtual_dom$VirtualDom$text(
										_Utils_eq(context, mdgriffith$stylish_elephants$Internal$Model$asParagraph) ? (str + ' ') : str)),
								htmls),
							existingStyles) : _Utils_Tuple2(
							A2(
								elm$core$List$cons,
								_Utils_Tuple2(
									key,
									mdgriffith$stylish_elephants$Internal$Model$textElement(
										_Utils_eq(context, mdgriffith$stylish_elephants$Internal$Model$asParagraph) ? (str + ' ') : str)),
								htmls),
							existingStyles);
					default:
						return _Utils_Tuple2(htmls, existingStyles);
				}
			});
		var gather = F2(
			function (child, _n6) {
				var htmls = _n6.a;
				var existingStyles = _n6.b;
				switch (child.$) {
					case 0:
						var html = child.a;
						return _Utils_eq(context, mdgriffith$stylish_elephants$Internal$Model$asParagraph) ? _Utils_Tuple2(
							A2(
								elm$core$List$cons,
								html(context),
								A2(elm$core$List$cons, mdgriffith$stylish_elephants$Internal$Model$space, htmls)),
							existingStyles) : _Utils_Tuple2(
							A2(
								elm$core$List$cons,
								html(context),
								htmls),
							existingStyles);
					case 1:
						var styled = child.a;
						return _Utils_eq(context, mdgriffith$stylish_elephants$Internal$Model$asParagraph) ? _Utils_Tuple2(
							A2(
								elm$core$List$cons,
								A2(styled.cB, mdgriffith$stylish_elephants$Internal$Model$NoStyleSheet, context),
								A2(elm$core$List$cons, mdgriffith$stylish_elephants$Internal$Model$space, htmls)),
							_Utils_ap(styled.M, existingStyles)) : _Utils_Tuple2(
							A2(
								elm$core$List$cons,
								A2(styled.cB, mdgriffith$stylish_elephants$Internal$Model$NoStyleSheet, context),
								htmls),
							_Utils_ap(styled.M, existingStyles));
					case 2:
						var str = child.a;
						return (_Utils_eq(context, mdgriffith$stylish_elephants$Internal$Model$asEl) || _Utils_eq(context, mdgriffith$stylish_elephants$Internal$Model$asParagraph)) ? _Utils_Tuple2(
							A2(
								elm$core$List$cons,
								elm$virtual_dom$VirtualDom$text(
									_Utils_eq(context, mdgriffith$stylish_elephants$Internal$Model$asParagraph) ? (str + ' ') : str),
								htmls),
							existingStyles) : _Utils_Tuple2(
							A2(
								elm$core$List$cons,
								mdgriffith$stylish_elephants$Internal$Model$textElement(
									_Utils_eq(context, mdgriffith$stylish_elephants$Internal$Model$asParagraph) ? (str + ' ') : str),
								htmls),
							existingStyles);
					default:
						return _Utils_Tuple2(htmls, existingStyles);
				}
			});
		if (children.$ === 1) {
			var keyedChildren = children.a;
			var _n1 = A3(
				elm$core$List$foldr,
				gatherKeyed,
				_Utils_Tuple2(_List_Nil, rendered.M),
				keyedChildren);
			var keyed = _n1.a;
			var styles = _n1.b;
			if (!styles.b) {
				return mdgriffith$stylish_elephants$Internal$Model$Unstyled(
					A5(
						mdgriffith$stylish_elephants$Internal$Model$finalizeNode,
						rendered.S,
						rendered.U,
						rendered.O,
						mdgriffith$stylish_elephants$Internal$Model$Keyed(
							_Utils_ap(
								A2(
									elm$core$List$map,
									function (x) {
										return _Utils_Tuple2('nearby-elements-pls', x);
									},
									rendered.P),
								keyed)),
						mdgriffith$stylish_elephants$Internal$Model$NoStyleSheet));
			} else {
				return mdgriffith$stylish_elephants$Internal$Model$Styled(
					{
						cB: A4(
							mdgriffith$stylish_elephants$Internal$Model$finalizeNode,
							rendered.S,
							rendered.U,
							rendered.O,
							mdgriffith$stylish_elephants$Internal$Model$Keyed(
								_Utils_ap(
									A2(
										elm$core$List$map,
										function (x) {
											return _Utils_Tuple2('nearby-elements-pls', x);
										},
										rendered.P),
									keyed))),
						M: styles
					});
			}
		} else {
			var unkeyedChildren = children.a;
			var _n3 = A3(
				elm$core$List$foldr,
				gather,
				_Utils_Tuple2(_List_Nil, rendered.M),
				unkeyedChildren);
			var unkeyed = _n3.a;
			var styles = _n3.b;
			if (!styles.b) {
				return mdgriffith$stylish_elephants$Internal$Model$Unstyled(
					A5(
						mdgriffith$stylish_elephants$Internal$Model$finalizeNode,
						rendered.S,
						rendered.U,
						rendered.O,
						mdgriffith$stylish_elephants$Internal$Model$Unkeyed(
							_Utils_ap(rendered.P, unkeyed)),
						mdgriffith$stylish_elephants$Internal$Model$NoStyleSheet));
			} else {
				return mdgriffith$stylish_elephants$Internal$Model$Styled(
					{
						cB: A4(
							mdgriffith$stylish_elephants$Internal$Model$finalizeNode,
							rendered.S,
							rendered.U,
							rendered.O,
							mdgriffith$stylish_elephants$Internal$Model$Unkeyed(
								_Utils_ap(rendered.P, unkeyed))),
						M: styles
					});
			}
		}
	});
var elm$core$Bitwise$or = _Bitwise_or;
var mdgriffith$stylish_elephants$Internal$Flag$add = F2(
	function (myFlag, _n0) {
		var one = _n0.a;
		var two = _n0.b;
		if (!myFlag.$) {
			var first = myFlag.a;
			return A2(mdgriffith$stylish_elephants$Internal$Flag$Field, first | one, two);
		} else {
			var second = myFlag.a;
			return A2(mdgriffith$stylish_elephants$Internal$Flag$Field, one, second | two);
		}
	});
var mdgriffith$stylish_elephants$Internal$Flag$height = mdgriffith$stylish_elephants$Internal$Flag$flag(7);
var mdgriffith$stylish_elephants$Internal$Flag$heightContent = mdgriffith$stylish_elephants$Internal$Flag$flag(36);
var mdgriffith$stylish_elephants$Internal$Flag$merge = F2(
	function (_n0, _n1) {
		var one = _n0.a;
		var two = _n0.b;
		var three = _n1.a;
		var four = _n1.b;
		return A2(mdgriffith$stylish_elephants$Internal$Flag$Field, one | three, two | four);
	});
var mdgriffith$stylish_elephants$Internal$Flag$width = mdgriffith$stylish_elephants$Internal$Flag$flag(6);
var mdgriffith$stylish_elephants$Internal$Flag$widthContent = mdgriffith$stylish_elephants$Internal$Flag$flag(38);
var mdgriffith$stylish_elephants$Internal$Flag$xAlign = mdgriffith$stylish_elephants$Internal$Flag$flag(30);
var mdgriffith$stylish_elephants$Internal$Flag$yAlign = mdgriffith$stylish_elephants$Internal$Flag$flag(29);
var mdgriffith$stylish_elephants$Internal$Model$Behind = 5;
var mdgriffith$stylish_elephants$Internal$Model$Single = F3(
	function (a, b, c) {
		return {$: 3, a: a, b: b, c: c};
	});
var mdgriffith$stylish_elephants$Internal$Model$Transform = function (a) {
	return {$: 9, a: a};
};
var mdgriffith$stylish_elephants$Internal$Model$Embedded = F2(
	function (a, b) {
		return {$: 2, a: a, b: b};
	});
var mdgriffith$stylish_elephants$Internal$Model$NodeName = function (a) {
	return {$: 1, a: a};
};
var mdgriffith$stylish_elephants$Internal$Model$addNodeName = F2(
	function (newNode, old) {
		switch (old.$) {
			case 0:
				return mdgriffith$stylish_elephants$Internal$Model$NodeName(newNode);
			case 1:
				var name = old.a;
				return A2(mdgriffith$stylish_elephants$Internal$Model$Embedded, name, newNode);
			default:
				var x = old.a;
				var y = old.b;
				return A2(mdgriffith$stylish_elephants$Internal$Model$Embedded, x, y);
		}
	});
var mdgriffith$stylish_elephants$Internal$Model$alignXName = function (align) {
	switch (align) {
		case 0:
			return mdgriffith$stylish_elephants$Internal$Style$classes.aQ + (' ' + mdgriffith$stylish_elephants$Internal$Style$classes.a8);
		case 2:
			return mdgriffith$stylish_elephants$Internal$Style$classes.aQ + (' ' + mdgriffith$stylish_elephants$Internal$Style$classes.a9);
		default:
			return mdgriffith$stylish_elephants$Internal$Style$classes.aQ + (' ' + mdgriffith$stylish_elephants$Internal$Style$classes.b$);
	}
};
var mdgriffith$stylish_elephants$Internal$Model$alignYName = function (align) {
	switch (align) {
		case 0:
			return mdgriffith$stylish_elephants$Internal$Style$classes.aR + (' ' + mdgriffith$stylish_elephants$Internal$Style$classes.b5);
		case 2:
			return mdgriffith$stylish_elephants$Internal$Style$classes.aR + (' ' + mdgriffith$stylish_elephants$Internal$Style$classes.b_);
		default:
			return mdgriffith$stylish_elephants$Internal$Style$classes.aR + (' ' + mdgriffith$stylish_elephants$Internal$Style$classes.b0);
	}
};
var mdgriffith$stylish_elephants$Internal$Model$FullTransform = F4(
	function (a, b, c, d) {
		return {$: 2, a: a, b: b, c: c, d: d};
	});
var mdgriffith$stylish_elephants$Internal$Model$Moved = function (a) {
	return {$: 1, a: a};
};
var mdgriffith$stylish_elephants$Internal$Model$composeTransformation = F2(
	function (transform, component) {
		switch (transform.$) {
			case 0:
				switch (component.$) {
					case 0:
						var x = component.a;
						return mdgriffith$stylish_elephants$Internal$Model$Moved(
							_Utils_Tuple3(x, 0, 0));
					case 1:
						var y = component.a;
						return mdgriffith$stylish_elephants$Internal$Model$Moved(
							_Utils_Tuple3(0, y, 0));
					case 2:
						var z = component.a;
						return mdgriffith$stylish_elephants$Internal$Model$Moved(
							_Utils_Tuple3(0, 0, z));
					case 3:
						var xyz = component.a;
						return mdgriffith$stylish_elephants$Internal$Model$Moved(xyz);
					case 4:
						var xyz = component.a;
						var angle = component.b;
						return A4(
							mdgriffith$stylish_elephants$Internal$Model$FullTransform,
							_Utils_Tuple3(0, 0, 0),
							_Utils_Tuple3(1, 1, 1),
							xyz,
							angle);
					default:
						var xyz = component.a;
						return A4(
							mdgriffith$stylish_elephants$Internal$Model$FullTransform,
							_Utils_Tuple3(0, 0, 0),
							xyz,
							_Utils_Tuple3(0, 0, 1),
							0);
				}
			case 1:
				var moved = transform.a;
				var x = moved.a;
				var y = moved.b;
				var z = moved.c;
				switch (component.$) {
					case 0:
						var newX = component.a;
						return mdgriffith$stylish_elephants$Internal$Model$Moved(
							_Utils_Tuple3(newX, y, z));
					case 1:
						var newY = component.a;
						return mdgriffith$stylish_elephants$Internal$Model$Moved(
							_Utils_Tuple3(x, newY, z));
					case 2:
						var newZ = component.a;
						return mdgriffith$stylish_elephants$Internal$Model$Moved(
							_Utils_Tuple3(x, y, newZ));
					case 3:
						var xyz = component.a;
						return mdgriffith$stylish_elephants$Internal$Model$Moved(xyz);
					case 4:
						var xyz = component.a;
						var angle = component.b;
						return A4(
							mdgriffith$stylish_elephants$Internal$Model$FullTransform,
							moved,
							_Utils_Tuple3(1, 1, 1),
							xyz,
							angle);
					default:
						var scale = component.a;
						return A4(
							mdgriffith$stylish_elephants$Internal$Model$FullTransform,
							moved,
							scale,
							_Utils_Tuple3(0, 0, 1),
							0);
				}
			default:
				var moved = transform.a;
				var x = moved.a;
				var y = moved.b;
				var z = moved.c;
				var scaled = transform.b;
				var origin = transform.c;
				var angle = transform.d;
				switch (component.$) {
					case 0:
						var newX = component.a;
						return A4(
							mdgriffith$stylish_elephants$Internal$Model$FullTransform,
							_Utils_Tuple3(newX, y, z),
							scaled,
							origin,
							angle);
					case 1:
						var newY = component.a;
						return A4(
							mdgriffith$stylish_elephants$Internal$Model$FullTransform,
							_Utils_Tuple3(x, newY, z),
							scaled,
							origin,
							angle);
					case 2:
						var newZ = component.a;
						return A4(
							mdgriffith$stylish_elephants$Internal$Model$FullTransform,
							_Utils_Tuple3(x, y, newZ),
							scaled,
							origin,
							angle);
					case 3:
						var newMove = component.a;
						return A4(mdgriffith$stylish_elephants$Internal$Model$FullTransform, newMove, scaled, origin, angle);
					case 4:
						var newOrigin = component.a;
						var newAngle = component.b;
						return A4(mdgriffith$stylish_elephants$Internal$Model$FullTransform, moved, scaled, newOrigin, newAngle);
					default:
						var newScale = component.a;
						return A4(mdgriffith$stylish_elephants$Internal$Model$FullTransform, moved, newScale, origin, angle);
				}
		}
	});
var mdgriffith$stylish_elephants$Internal$Model$renderHeight = function (h) {
	switch (h.$) {
		case 0:
			var px = h.a;
			var val = elm$core$String$fromInt(px);
			var name = 'height-px-' + val;
			return _Utils_Tuple3(
				mdgriffith$stylish_elephants$Internal$Flag$none,
				name,
				_List_fromArray(
					[
						A3(mdgriffith$stylish_elephants$Internal$Model$Single, name, 'height', val + 'px')
					]));
		case 1:
			return _Utils_Tuple3(
				A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$heightContent, mdgriffith$stylish_elephants$Internal$Flag$none),
				mdgriffith$stylish_elephants$Internal$Style$classes.ao,
				_List_Nil);
		case 2:
			var portion = h.a;
			return (portion === 1) ? _Utils_Tuple3(
				A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$heightFill, mdgriffith$stylish_elephants$Internal$Flag$none),
				mdgriffith$stylish_elephants$Internal$Style$classes.aY,
				_List_Nil) : _Utils_Tuple3(
				A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$heightFill, mdgriffith$stylish_elephants$Internal$Flag$none),
				mdgriffith$stylish_elephants$Internal$Style$classes.bo + (' height-fill-' + elm$core$String$fromInt(portion)),
				_List_fromArray(
					[
						A3(
						mdgriffith$stylish_elephants$Internal$Model$Single,
						mdgriffith$stylish_elephants$Internal$Style$classes.b6 + ('.' + (mdgriffith$stylish_elephants$Internal$Style$classes.L + (' > ' + mdgriffith$stylish_elephants$Internal$Style$dot(
							'height-fill-' + elm$core$String$fromInt(portion))))),
						'flex-grow',
						elm$core$String$fromInt(portion * 100000))
					]));
		case 3:
			var minSize = h.a;
			var len = h.b;
			var cls = 'min-height-' + elm$core$String$fromInt(minSize);
			var style = A3(
				mdgriffith$stylish_elephants$Internal$Model$Single,
				cls,
				'min-height',
				elm$core$String$fromInt(minSize) + 'px');
			var _n1 = mdgriffith$stylish_elephants$Internal$Model$renderHeight(len);
			var newFlag = _n1.a;
			var newAttrs = _n1.b;
			var newStyle = _n1.c;
			return _Utils_Tuple3(
				A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$heightBetween, newFlag),
				cls + (' ' + newAttrs),
				A2(elm$core$List$cons, style, newStyle));
		default:
			var maxSize = h.a;
			var len = h.b;
			var cls = 'max-height-' + elm$core$String$fromInt(maxSize);
			var style = A3(
				mdgriffith$stylish_elephants$Internal$Model$Single,
				cls,
				'max-height',
				elm$core$String$fromInt(maxSize) + 'px');
			var _n2 = mdgriffith$stylish_elephants$Internal$Model$renderHeight(len);
			var newFlag = _n2.a;
			var newAttrs = _n2.b;
			var newStyle = _n2.c;
			return _Utils_Tuple3(
				A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$heightBetween, newFlag),
				cls + (' ' + newAttrs),
				A2(elm$core$List$cons, style, newStyle));
	}
};
var mdgriffith$stylish_elephants$Internal$Model$renderWidth = function (w) {
	switch (w.$) {
		case 0:
			var px = w.a;
			return _Utils_Tuple3(
				mdgriffith$stylish_elephants$Internal$Flag$none,
				mdgriffith$stylish_elephants$Internal$Style$classes.bW + (' width-px-' + elm$core$String$fromInt(px)),
				_List_fromArray(
					[
						A3(
						mdgriffith$stylish_elephants$Internal$Model$Single,
						'width-px-' + elm$core$String$fromInt(px),
						'width',
						elm$core$String$fromInt(px) + 'px')
					]));
		case 1:
			return _Utils_Tuple3(
				A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$widthContent, mdgriffith$stylish_elephants$Internal$Flag$none),
				mdgriffith$stylish_elephants$Internal$Style$classes.a5,
				_List_Nil);
		case 2:
			var portion = w.a;
			return (portion === 1) ? _Utils_Tuple3(
				A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$widthFill, mdgriffith$stylish_elephants$Internal$Flag$none),
				mdgriffith$stylish_elephants$Internal$Style$classes.a6,
				_List_Nil) : _Utils_Tuple3(
				A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$widthFill, mdgriffith$stylish_elephants$Internal$Flag$none),
				mdgriffith$stylish_elephants$Internal$Style$classes.bX + (' width-fill-' + elm$core$String$fromInt(portion)),
				_List_fromArray(
					[
						A3(
						mdgriffith$stylish_elephants$Internal$Model$Single,
						mdgriffith$stylish_elephants$Internal$Style$classes.b6 + ('.' + (mdgriffith$stylish_elephants$Internal$Style$classes.L + (' > ' + mdgriffith$stylish_elephants$Internal$Style$dot(
							'width-fill-' + elm$core$String$fromInt(portion))))),
						'flex-grow',
						elm$core$String$fromInt(portion * 100000))
					]));
		case 3:
			var minSize = w.a;
			var len = w.b;
			var cls = 'min-width-' + elm$core$String$fromInt(minSize);
			var style = A3(
				mdgriffith$stylish_elephants$Internal$Model$Single,
				cls,
				'min-width',
				elm$core$String$fromInt(minSize) + 'px');
			var _n1 = mdgriffith$stylish_elephants$Internal$Model$renderWidth(len);
			var newFlag = _n1.a;
			var newAttrs = _n1.b;
			var newStyle = _n1.c;
			return _Utils_Tuple3(
				A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$widthBetween, newFlag),
				cls + (' ' + newAttrs),
				A2(elm$core$List$cons, style, newStyle));
		default:
			var maxSize = w.a;
			var len = w.b;
			var cls = 'max-width-' + elm$core$String$fromInt(maxSize);
			var style = A3(
				mdgriffith$stylish_elephants$Internal$Model$Single,
				cls,
				'max-width',
				elm$core$String$fromInt(maxSize) + 'px');
			var _n2 = mdgriffith$stylish_elephants$Internal$Model$renderWidth(len);
			var newFlag = _n2.a;
			var newAttrs = _n2.b;
			var newStyle = _n2.c;
			return _Utils_Tuple3(
				A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$widthBetween, newFlag),
				cls + (' ' + newAttrs),
				A2(elm$core$List$cons, style, newStyle));
	}
};
var mdgriffith$stylish_elephants$Internal$Model$gatherAttrRecursive = F8(
	function (classes, node, has, transform, styles, attrs, children, elementAttrs) {
		gatherAttrRecursive:
		while (true) {
			if (!elementAttrs.b) {
				var _n1 = mdgriffith$stylish_elephants$Internal$Model$transformClass(transform);
				if (_n1.$ === 1) {
					return {
						O: A2(
							elm$core$List$cons,
							elm$html$Html$Attributes$class(classes),
							attrs),
						P: children,
						S: has,
						U: node,
						M: styles
					};
				} else {
					var _class = _n1.a;
					return {
						O: A2(
							elm$core$List$cons,
							elm$html$Html$Attributes$class(classes + (' ' + _class)),
							attrs),
						P: children,
						S: has,
						U: node,
						M: A2(
							elm$core$List$cons,
							mdgriffith$stylish_elephants$Internal$Model$Transform(transform),
							styles)
					};
				}
			} else {
				var attribute = elementAttrs.a;
				var remaining = elementAttrs.b;
				switch (attribute.$) {
					case 0:
						var $temp$classes = classes,
							$temp$node = node,
							$temp$has = has,
							$temp$transform = transform,
							$temp$styles = styles,
							$temp$attrs = attrs,
							$temp$children = children,
							$temp$elementAttrs = remaining;
						classes = $temp$classes;
						node = $temp$node;
						has = $temp$has;
						transform = $temp$transform;
						styles = $temp$styles;
						attrs = $temp$attrs;
						children = $temp$children;
						elementAttrs = $temp$elementAttrs;
						continue gatherAttrRecursive;
					case 3:
						var flag = attribute.a;
						var exactClassName = attribute.b;
						if (A2(mdgriffith$stylish_elephants$Internal$Flag$present, flag, has)) {
							var $temp$classes = classes,
								$temp$node = node,
								$temp$has = has,
								$temp$transform = transform,
								$temp$styles = styles,
								$temp$attrs = attrs,
								$temp$children = children,
								$temp$elementAttrs = remaining;
							classes = $temp$classes;
							node = $temp$node;
							has = $temp$has;
							transform = $temp$transform;
							styles = $temp$styles;
							attrs = $temp$attrs;
							children = $temp$children;
							elementAttrs = $temp$elementAttrs;
							continue gatherAttrRecursive;
						} else {
							var $temp$classes = exactClassName + (' ' + classes),
								$temp$node = node,
								$temp$has = A2(mdgriffith$stylish_elephants$Internal$Flag$add, flag, has),
								$temp$transform = transform,
								$temp$styles = styles,
								$temp$attrs = attrs,
								$temp$children = children,
								$temp$elementAttrs = remaining;
							classes = $temp$classes;
							node = $temp$node;
							has = $temp$has;
							transform = $temp$transform;
							styles = $temp$styles;
							attrs = $temp$attrs;
							children = $temp$children;
							elementAttrs = $temp$elementAttrs;
							continue gatherAttrRecursive;
						}
					case 1:
						var actualAttribute = attribute.a;
						var $temp$classes = classes,
							$temp$node = node,
							$temp$has = has,
							$temp$transform = transform,
							$temp$styles = styles,
							$temp$attrs = A2(elm$core$List$cons, actualAttribute, attrs),
							$temp$children = children,
							$temp$elementAttrs = remaining;
						classes = $temp$classes;
						node = $temp$node;
						has = $temp$has;
						transform = $temp$transform;
						styles = $temp$styles;
						attrs = $temp$attrs;
						children = $temp$children;
						elementAttrs = $temp$elementAttrs;
						continue gatherAttrRecursive;
					case 4:
						var flag = attribute.a;
						var style = attribute.b;
						if (A2(mdgriffith$stylish_elephants$Internal$Flag$present, flag, has)) {
							var $temp$classes = classes,
								$temp$node = node,
								$temp$has = has,
								$temp$transform = transform,
								$temp$styles = styles,
								$temp$attrs = attrs,
								$temp$children = children,
								$temp$elementAttrs = remaining;
							classes = $temp$classes;
							node = $temp$node;
							has = $temp$has;
							transform = $temp$transform;
							styles = $temp$styles;
							attrs = $temp$attrs;
							children = $temp$children;
							elementAttrs = $temp$elementAttrs;
							continue gatherAttrRecursive;
						} else {
							var $temp$classes = mdgriffith$stylish_elephants$Internal$Model$getStyleName(style) + (' ' + classes),
								$temp$node = node,
								$temp$has = A2(mdgriffith$stylish_elephants$Internal$Flag$add, flag, has),
								$temp$transform = transform,
								$temp$styles = A2(elm$core$List$cons, style, styles),
								$temp$attrs = attrs,
								$temp$children = children,
								$temp$elementAttrs = remaining;
							classes = $temp$classes;
							node = $temp$node;
							has = $temp$has;
							transform = $temp$transform;
							styles = $temp$styles;
							attrs = $temp$attrs;
							children = $temp$children;
							elementAttrs = $temp$elementAttrs;
							continue gatherAttrRecursive;
						}
					case 10:
						var flag = attribute.a;
						var component = attribute.b;
						var $temp$classes = classes,
							$temp$node = node,
							$temp$has = A2(mdgriffith$stylish_elephants$Internal$Flag$add, flag, has),
							$temp$transform = A2(mdgriffith$stylish_elephants$Internal$Model$composeTransformation, transform, component),
							$temp$styles = styles,
							$temp$attrs = attrs,
							$temp$children = children,
							$temp$elementAttrs = remaining;
						classes = $temp$classes;
						node = $temp$node;
						has = $temp$has;
						transform = $temp$transform;
						styles = $temp$styles;
						attrs = $temp$attrs;
						children = $temp$children;
						elementAttrs = $temp$elementAttrs;
						continue gatherAttrRecursive;
					case 7:
						var width = attribute.a;
						if (A2(mdgriffith$stylish_elephants$Internal$Flag$present, mdgriffith$stylish_elephants$Internal$Flag$width, has)) {
							var $temp$classes = classes,
								$temp$node = node,
								$temp$has = has,
								$temp$transform = transform,
								$temp$styles = styles,
								$temp$attrs = attrs,
								$temp$children = children,
								$temp$elementAttrs = remaining;
							classes = $temp$classes;
							node = $temp$node;
							has = $temp$has;
							transform = $temp$transform;
							styles = $temp$styles;
							attrs = $temp$attrs;
							children = $temp$children;
							elementAttrs = $temp$elementAttrs;
							continue gatherAttrRecursive;
						} else {
							switch (width.$) {
								case 0:
									var px = width.a;
									var $temp$classes = (mdgriffith$stylish_elephants$Internal$Style$classes.bW + (' width-px-' + elm$core$String$fromInt(px))) + (' ' + classes),
										$temp$node = node,
										$temp$has = A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$width, has),
										$temp$transform = transform,
										$temp$styles = A2(
										elm$core$List$cons,
										A3(
											mdgriffith$stylish_elephants$Internal$Model$Single,
											'width-px-' + elm$core$String$fromInt(px),
											'width',
											elm$core$String$fromInt(px) + 'px'),
										styles),
										$temp$attrs = attrs,
										$temp$children = children,
										$temp$elementAttrs = remaining;
									classes = $temp$classes;
									node = $temp$node;
									has = $temp$has;
									transform = $temp$transform;
									styles = $temp$styles;
									attrs = $temp$attrs;
									children = $temp$children;
									elementAttrs = $temp$elementAttrs;
									continue gatherAttrRecursive;
								case 1:
									var $temp$classes = classes + (' ' + mdgriffith$stylish_elephants$Internal$Style$classes.a5),
										$temp$node = node,
										$temp$has = A2(
										mdgriffith$stylish_elephants$Internal$Flag$add,
										mdgriffith$stylish_elephants$Internal$Flag$widthContent,
										A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$width, has)),
										$temp$transform = transform,
										$temp$styles = styles,
										$temp$attrs = attrs,
										$temp$children = children,
										$temp$elementAttrs = remaining;
									classes = $temp$classes;
									node = $temp$node;
									has = $temp$has;
									transform = $temp$transform;
									styles = $temp$styles;
									attrs = $temp$attrs;
									children = $temp$children;
									elementAttrs = $temp$elementAttrs;
									continue gatherAttrRecursive;
								case 2:
									var portion = width.a;
									if (portion === 1) {
										var $temp$classes = classes + (' ' + mdgriffith$stylish_elephants$Internal$Style$classes.a6),
											$temp$node = node,
											$temp$has = A2(
											mdgriffith$stylish_elephants$Internal$Flag$add,
											mdgriffith$stylish_elephants$Internal$Flag$widthFill,
											A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$width, has)),
											$temp$transform = transform,
											$temp$styles = styles,
											$temp$attrs = attrs,
											$temp$children = children,
											$temp$elementAttrs = remaining;
										classes = $temp$classes;
										node = $temp$node;
										has = $temp$has;
										transform = $temp$transform;
										styles = $temp$styles;
										attrs = $temp$attrs;
										children = $temp$children;
										elementAttrs = $temp$elementAttrs;
										continue gatherAttrRecursive;
									} else {
										var $temp$classes = classes + (' ' + (mdgriffith$stylish_elephants$Internal$Style$classes.bX + (' width-fill-' + elm$core$String$fromInt(portion)))),
											$temp$node = node,
											$temp$has = A2(
											mdgriffith$stylish_elephants$Internal$Flag$add,
											mdgriffith$stylish_elephants$Internal$Flag$widthFill,
											A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$width, has)),
											$temp$transform = transform,
											$temp$styles = A2(
											elm$core$List$cons,
											A3(
												mdgriffith$stylish_elephants$Internal$Model$Single,
												mdgriffith$stylish_elephants$Internal$Style$classes.b6 + ('.' + (mdgriffith$stylish_elephants$Internal$Style$classes.L + (' > ' + mdgriffith$stylish_elephants$Internal$Style$dot(
													'width-fill-' + elm$core$String$fromInt(portion))))),
												'flex-grow',
												elm$core$String$fromInt(portion * 100000)),
											styles),
											$temp$attrs = attrs,
											$temp$children = children,
											$temp$elementAttrs = remaining;
										classes = $temp$classes;
										node = $temp$node;
										has = $temp$has;
										transform = $temp$transform;
										styles = $temp$styles;
										attrs = $temp$attrs;
										children = $temp$children;
										elementAttrs = $temp$elementAttrs;
										continue gatherAttrRecursive;
									}
								default:
									var _n4 = mdgriffith$stylish_elephants$Internal$Model$renderWidth(width);
									var addToFlags = _n4.a;
									var newClass = _n4.b;
									var newStyles = _n4.c;
									var $temp$classes = classes + (' ' + newClass),
										$temp$node = node,
										$temp$has = A2(mdgriffith$stylish_elephants$Internal$Flag$merge, addToFlags, has),
										$temp$transform = transform,
										$temp$styles = _Utils_ap(newStyles, styles),
										$temp$attrs = attrs,
										$temp$children = children,
										$temp$elementAttrs = remaining;
									classes = $temp$classes;
									node = $temp$node;
									has = $temp$has;
									transform = $temp$transform;
									styles = $temp$styles;
									attrs = $temp$attrs;
									children = $temp$children;
									elementAttrs = $temp$elementAttrs;
									continue gatherAttrRecursive;
							}
						}
					case 8:
						var height = attribute.a;
						if (A2(mdgriffith$stylish_elephants$Internal$Flag$present, mdgriffith$stylish_elephants$Internal$Flag$height, has)) {
							var $temp$classes = classes,
								$temp$node = node,
								$temp$has = has,
								$temp$transform = transform,
								$temp$styles = styles,
								$temp$attrs = attrs,
								$temp$children = children,
								$temp$elementAttrs = remaining;
							classes = $temp$classes;
							node = $temp$node;
							has = $temp$has;
							transform = $temp$transform;
							styles = $temp$styles;
							attrs = $temp$attrs;
							children = $temp$children;
							elementAttrs = $temp$elementAttrs;
							continue gatherAttrRecursive;
						} else {
							switch (height.$) {
								case 0:
									var px = height.a;
									var val = elm$core$String$fromInt(px) + 'px';
									var name = 'height-px-' + val;
									var $temp$classes = name + (' ' + classes),
										$temp$node = node,
										$temp$has = A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$height, has),
										$temp$transform = transform,
										$temp$styles = A2(
										elm$core$List$cons,
										A3(mdgriffith$stylish_elephants$Internal$Model$Single, name, 'height ', val),
										styles),
										$temp$attrs = attrs,
										$temp$children = children,
										$temp$elementAttrs = remaining;
									classes = $temp$classes;
									node = $temp$node;
									has = $temp$has;
									transform = $temp$transform;
									styles = $temp$styles;
									attrs = $temp$attrs;
									children = $temp$children;
									elementAttrs = $temp$elementAttrs;
									continue gatherAttrRecursive;
								case 1:
									var $temp$classes = mdgriffith$stylish_elephants$Internal$Style$classes.ao + (' ' + classes),
										$temp$node = node,
										$temp$has = A2(
										mdgriffith$stylish_elephants$Internal$Flag$add,
										mdgriffith$stylish_elephants$Internal$Flag$heightContent,
										A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$height, has)),
										$temp$transform = transform,
										$temp$styles = styles,
										$temp$attrs = attrs,
										$temp$children = children,
										$temp$elementAttrs = remaining;
									classes = $temp$classes;
									node = $temp$node;
									has = $temp$has;
									transform = $temp$transform;
									styles = $temp$styles;
									attrs = $temp$attrs;
									children = $temp$children;
									elementAttrs = $temp$elementAttrs;
									continue gatherAttrRecursive;
								case 2:
									var portion = height.a;
									if (portion === 1) {
										var $temp$classes = mdgriffith$stylish_elephants$Internal$Style$classes.aY + (' ' + classes),
											$temp$node = node,
											$temp$has = A2(
											mdgriffith$stylish_elephants$Internal$Flag$add,
											mdgriffith$stylish_elephants$Internal$Flag$heightFill,
											A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$height, has)),
											$temp$transform = transform,
											$temp$styles = styles,
											$temp$attrs = attrs,
											$temp$children = children,
											$temp$elementAttrs = remaining;
										classes = $temp$classes;
										node = $temp$node;
										has = $temp$has;
										transform = $temp$transform;
										styles = $temp$styles;
										attrs = $temp$attrs;
										children = $temp$children;
										elementAttrs = $temp$elementAttrs;
										continue gatherAttrRecursive;
									} else {
										var $temp$classes = classes + (' ' + (mdgriffith$stylish_elephants$Internal$Style$classes.bo + (' height-fill-' + elm$core$String$fromInt(portion)))),
											$temp$node = node,
											$temp$has = A2(
											mdgriffith$stylish_elephants$Internal$Flag$add,
											mdgriffith$stylish_elephants$Internal$Flag$heightFill,
											A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$height, has)),
											$temp$transform = transform,
											$temp$styles = A2(
											elm$core$List$cons,
											A3(
												mdgriffith$stylish_elephants$Internal$Model$Single,
												mdgriffith$stylish_elephants$Internal$Style$classes.b6 + ('.' + (mdgriffith$stylish_elephants$Internal$Style$classes.L + (' > ' + mdgriffith$stylish_elephants$Internal$Style$dot(
													'height-fill-' + elm$core$String$fromInt(portion))))),
												'flex-grow',
												elm$core$String$fromInt(portion * 100000)),
											styles),
											$temp$attrs = attrs,
											$temp$children = children,
											$temp$elementAttrs = remaining;
										classes = $temp$classes;
										node = $temp$node;
										has = $temp$has;
										transform = $temp$transform;
										styles = $temp$styles;
										attrs = $temp$attrs;
										children = $temp$children;
										elementAttrs = $temp$elementAttrs;
										continue gatherAttrRecursive;
									}
								default:
									var _n6 = mdgriffith$stylish_elephants$Internal$Model$renderHeight(height);
									var addToFlags = _n6.a;
									var newClass = _n6.b;
									var newStyles = _n6.c;
									var $temp$classes = classes + (' ' + newClass),
										$temp$node = node,
										$temp$has = A2(mdgriffith$stylish_elephants$Internal$Flag$merge, addToFlags, has),
										$temp$transform = transform,
										$temp$styles = _Utils_ap(newStyles, styles),
										$temp$attrs = attrs,
										$temp$children = children,
										$temp$elementAttrs = remaining;
									classes = $temp$classes;
									node = $temp$node;
									has = $temp$has;
									transform = $temp$transform;
									styles = $temp$styles;
									attrs = $temp$attrs;
									children = $temp$children;
									elementAttrs = $temp$elementAttrs;
									continue gatherAttrRecursive;
							}
						}
					case 2:
						var description = attribute.a;
						switch (description.$) {
							case 0:
								var $temp$classes = classes,
									$temp$node = A2(mdgriffith$stylish_elephants$Internal$Model$addNodeName, 'main', node),
									$temp$has = has,
									$temp$transform = transform,
									$temp$styles = styles,
									$temp$attrs = attrs,
									$temp$children = children,
									$temp$elementAttrs = remaining;
								classes = $temp$classes;
								node = $temp$node;
								has = $temp$has;
								transform = $temp$transform;
								styles = $temp$styles;
								attrs = $temp$attrs;
								children = $temp$children;
								elementAttrs = $temp$elementAttrs;
								continue gatherAttrRecursive;
							case 1:
								var $temp$classes = classes,
									$temp$node = A2(mdgriffith$stylish_elephants$Internal$Model$addNodeName, 'nav', node),
									$temp$has = has,
									$temp$transform = transform,
									$temp$styles = styles,
									$temp$attrs = attrs,
									$temp$children = children,
									$temp$elementAttrs = remaining;
								classes = $temp$classes;
								node = $temp$node;
								has = $temp$has;
								transform = $temp$transform;
								styles = $temp$styles;
								attrs = $temp$attrs;
								children = $temp$children;
								elementAttrs = $temp$elementAttrs;
								continue gatherAttrRecursive;
							case 2:
								var $temp$classes = classes,
									$temp$node = A2(mdgriffith$stylish_elephants$Internal$Model$addNodeName, 'footer', node),
									$temp$has = has,
									$temp$transform = transform,
									$temp$styles = styles,
									$temp$attrs = attrs,
									$temp$children = children,
									$temp$elementAttrs = remaining;
								classes = $temp$classes;
								node = $temp$node;
								has = $temp$has;
								transform = $temp$transform;
								styles = $temp$styles;
								attrs = $temp$attrs;
								children = $temp$children;
								elementAttrs = $temp$elementAttrs;
								continue gatherAttrRecursive;
							case 3:
								var $temp$classes = classes,
									$temp$node = A2(mdgriffith$stylish_elephants$Internal$Model$addNodeName, 'aside', node),
									$temp$has = has,
									$temp$transform = transform,
									$temp$styles = styles,
									$temp$attrs = attrs,
									$temp$children = children,
									$temp$elementAttrs = remaining;
								classes = $temp$classes;
								node = $temp$node;
								has = $temp$has;
								transform = $temp$transform;
								styles = $temp$styles;
								attrs = $temp$attrs;
								children = $temp$children;
								elementAttrs = $temp$elementAttrs;
								continue gatherAttrRecursive;
							case 4:
								var i = description.a;
								if (i <= 1) {
									var $temp$classes = classes,
										$temp$node = A2(mdgriffith$stylish_elephants$Internal$Model$addNodeName, 'h1', node),
										$temp$has = has,
										$temp$transform = transform,
										$temp$styles = styles,
										$temp$attrs = attrs,
										$temp$children = children,
										$temp$elementAttrs = remaining;
									classes = $temp$classes;
									node = $temp$node;
									has = $temp$has;
									transform = $temp$transform;
									styles = $temp$styles;
									attrs = $temp$attrs;
									children = $temp$children;
									elementAttrs = $temp$elementAttrs;
									continue gatherAttrRecursive;
								} else {
									if (i < 7) {
										var $temp$classes = classes,
											$temp$node = A2(
											mdgriffith$stylish_elephants$Internal$Model$addNodeName,
											'h' + elm$core$String$fromInt(i),
											node),
											$temp$has = has,
											$temp$transform = transform,
											$temp$styles = styles,
											$temp$attrs = attrs,
											$temp$children = children,
											$temp$elementAttrs = remaining;
										classes = $temp$classes;
										node = $temp$node;
										has = $temp$has;
										transform = $temp$transform;
										styles = $temp$styles;
										attrs = $temp$attrs;
										children = $temp$children;
										elementAttrs = $temp$elementAttrs;
										continue gatherAttrRecursive;
									} else {
										var $temp$classes = classes,
											$temp$node = A2(mdgriffith$stylish_elephants$Internal$Model$addNodeName, 'h6', node),
											$temp$has = has,
											$temp$transform = transform,
											$temp$styles = styles,
											$temp$attrs = attrs,
											$temp$children = children,
											$temp$elementAttrs = remaining;
										classes = $temp$classes;
										node = $temp$node;
										has = $temp$has;
										transform = $temp$transform;
										styles = $temp$styles;
										attrs = $temp$attrs;
										children = $temp$children;
										elementAttrs = $temp$elementAttrs;
										continue gatherAttrRecursive;
									}
								}
							case 8:
								var $temp$classes = classes,
									$temp$node = node,
									$temp$has = has,
									$temp$transform = transform,
									$temp$styles = styles,
									$temp$attrs = A2(
									elm$core$List$cons,
									A2(elm$virtual_dom$VirtualDom$attribute, 'role', 'button'),
									attrs),
									$temp$children = children,
									$temp$elementAttrs = remaining;
								classes = $temp$classes;
								node = $temp$node;
								has = $temp$has;
								transform = $temp$transform;
								styles = $temp$styles;
								attrs = $temp$attrs;
								children = $temp$children;
								elementAttrs = $temp$elementAttrs;
								continue gatherAttrRecursive;
							case 5:
								var label = description.a;
								var $temp$classes = classes,
									$temp$node = node,
									$temp$has = has,
									$temp$transform = transform,
									$temp$styles = styles,
									$temp$attrs = A2(
									elm$core$List$cons,
									A2(elm$virtual_dom$VirtualDom$attribute, 'aria-label', label),
									attrs),
									$temp$children = children,
									$temp$elementAttrs = remaining;
								classes = $temp$classes;
								node = $temp$node;
								has = $temp$has;
								transform = $temp$transform;
								styles = $temp$styles;
								attrs = $temp$attrs;
								children = $temp$children;
								elementAttrs = $temp$elementAttrs;
								continue gatherAttrRecursive;
							case 6:
								var $temp$classes = classes,
									$temp$node = node,
									$temp$has = has,
									$temp$transform = transform,
									$temp$styles = styles,
									$temp$attrs = A2(
									elm$core$List$cons,
									A2(elm$virtual_dom$VirtualDom$attribute, 'aria-live', 'polite'),
									attrs),
									$temp$children = children,
									$temp$elementAttrs = remaining;
								classes = $temp$classes;
								node = $temp$node;
								has = $temp$has;
								transform = $temp$transform;
								styles = $temp$styles;
								attrs = $temp$attrs;
								children = $temp$children;
								elementAttrs = $temp$elementAttrs;
								continue gatherAttrRecursive;
							default:
								var $temp$classes = classes,
									$temp$node = node,
									$temp$has = has,
									$temp$transform = transform,
									$temp$styles = styles,
									$temp$attrs = A2(
									elm$core$List$cons,
									A2(elm$virtual_dom$VirtualDom$attribute, 'aria-live', 'assertive'),
									attrs),
									$temp$children = children,
									$temp$elementAttrs = remaining;
								classes = $temp$classes;
								node = $temp$node;
								has = $temp$has;
								transform = $temp$transform;
								styles = $temp$styles;
								attrs = $temp$attrs;
								children = $temp$children;
								elementAttrs = $temp$elementAttrs;
								continue gatherAttrRecursive;
						}
					case 9:
						var location = attribute.a;
						var elem = attribute.b;
						var newStyles = function () {
							switch (elem.$) {
								case 3:
									return styles;
								case 2:
									var str = elem.a;
									return styles;
								case 0:
									var html = elem.a;
									return styles;
								default:
									var styled = elem.a;
									return _Utils_ap(styles, styled.M);
							}
						}();
						var newClasses = (location === 5) ? (mdgriffith$stylish_elephants$Internal$Style$classes.cx + (' ' + classes)) : classes;
						var nearbyElement = A2(
							elm$html$Html$div,
							_List_fromArray(
								[
									elm$html$Html$Attributes$class(
									function () {
										switch (location) {
											case 0:
												return A2(
													elm$core$String$join,
													' ',
													_List_fromArray(
														[mdgriffith$stylish_elephants$Internal$Style$classes.b6, mdgriffith$stylish_elephants$Internal$Style$classes.c7, mdgriffith$stylish_elephants$Internal$Style$classes.bZ]));
											case 1:
												return A2(
													elm$core$String$join,
													' ',
													_List_fromArray(
														[mdgriffith$stylish_elephants$Internal$Style$classes.b6, mdgriffith$stylish_elephants$Internal$Style$classes.c7, mdgriffith$stylish_elephants$Internal$Style$classes.b9]));
											case 2:
												return A2(
													elm$core$String$join,
													' ',
													_List_fromArray(
														[mdgriffith$stylish_elephants$Internal$Style$classes.b6, mdgriffith$stylish_elephants$Internal$Style$classes.c7, mdgriffith$stylish_elephants$Internal$Style$classes.cT]));
											case 3:
												return A2(
													elm$core$String$join,
													' ',
													_List_fromArray(
														[mdgriffith$stylish_elephants$Internal$Style$classes.b6, mdgriffith$stylish_elephants$Internal$Style$classes.c7, mdgriffith$stylish_elephants$Internal$Style$classes.cR]));
											case 4:
												return A2(
													elm$core$String$join,
													' ',
													_List_fromArray(
														[mdgriffith$stylish_elephants$Internal$Style$classes.b6, mdgriffith$stylish_elephants$Internal$Style$classes.c7, mdgriffith$stylish_elephants$Internal$Style$classes.cE]));
											default:
												return A2(
													elm$core$String$join,
													' ',
													_List_fromArray(
														[mdgriffith$stylish_elephants$Internal$Style$classes.b6, mdgriffith$stylish_elephants$Internal$Style$classes.c7, mdgriffith$stylish_elephants$Internal$Style$classes.b8]));
										}
									}())
								]),
							_List_fromArray(
								[
									function () {
									switch (elem.$) {
										case 3:
											return elm$virtual_dom$VirtualDom$text('');
										case 2:
											var str = elem.a;
											return mdgriffith$stylish_elephants$Internal$Model$textElement(str);
										case 0:
											var html = elem.a;
											return html(mdgriffith$stylish_elephants$Internal$Model$asEl);
										default:
											var styled = elem.a;
											return A2(styled.cB, mdgriffith$stylish_elephants$Internal$Model$NoStyleSheet, mdgriffith$stylish_elephants$Internal$Model$asEl);
									}
								}()
								]));
						var $temp$classes = newClasses,
							$temp$node = node,
							$temp$has = has,
							$temp$transform = transform,
							$temp$styles = newStyles,
							$temp$attrs = attrs,
							$temp$children = A2(elm$core$List$cons, nearbyElement, children),
							$temp$elementAttrs = remaining;
						classes = $temp$classes;
						node = $temp$node;
						has = $temp$has;
						transform = $temp$transform;
						styles = $temp$styles;
						attrs = $temp$attrs;
						children = $temp$children;
						elementAttrs = $temp$elementAttrs;
						continue gatherAttrRecursive;
					case 6:
						var x = attribute.a;
						if (A2(mdgriffith$stylish_elephants$Internal$Flag$present, mdgriffith$stylish_elephants$Internal$Flag$xAlign, has)) {
							var $temp$classes = classes,
								$temp$node = node,
								$temp$has = has,
								$temp$transform = transform,
								$temp$styles = styles,
								$temp$attrs = attrs,
								$temp$children = children,
								$temp$elementAttrs = remaining;
							classes = $temp$classes;
							node = $temp$node;
							has = $temp$has;
							transform = $temp$transform;
							styles = $temp$styles;
							attrs = $temp$attrs;
							children = $temp$children;
							elementAttrs = $temp$elementAttrs;
							continue gatherAttrRecursive;
						} else {
							var $temp$classes = mdgriffith$stylish_elephants$Internal$Model$alignXName(x) + (' ' + classes),
								$temp$node = node,
								$temp$has = function (flags) {
								switch (x) {
									case 1:
										return A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$centerX, flags);
									case 2:
										return A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$alignRight, flags);
									default:
										return flags;
								}
							}(
								A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$xAlign, has)),
								$temp$transform = transform,
								$temp$styles = styles,
								$temp$attrs = attrs,
								$temp$children = children,
								$temp$elementAttrs = remaining;
							classes = $temp$classes;
							node = $temp$node;
							has = $temp$has;
							transform = $temp$transform;
							styles = $temp$styles;
							attrs = $temp$attrs;
							children = $temp$children;
							elementAttrs = $temp$elementAttrs;
							continue gatherAttrRecursive;
						}
					default:
						var y = attribute.a;
						if (A2(mdgriffith$stylish_elephants$Internal$Flag$present, mdgriffith$stylish_elephants$Internal$Flag$yAlign, has)) {
							var $temp$classes = classes,
								$temp$node = node,
								$temp$has = has,
								$temp$transform = transform,
								$temp$styles = styles,
								$temp$attrs = attrs,
								$temp$children = children,
								$temp$elementAttrs = remaining;
							classes = $temp$classes;
							node = $temp$node;
							has = $temp$has;
							transform = $temp$transform;
							styles = $temp$styles;
							attrs = $temp$attrs;
							children = $temp$children;
							elementAttrs = $temp$elementAttrs;
							continue gatherAttrRecursive;
						} else {
							var $temp$classes = mdgriffith$stylish_elephants$Internal$Model$alignYName(y) + (' ' + classes),
								$temp$node = node,
								$temp$has = function (flags) {
								switch (y) {
									case 1:
										return A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$centerY, flags);
									case 2:
										return A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$alignBottom, flags);
									default:
										return flags;
								}
							}(
								A2(mdgriffith$stylish_elephants$Internal$Flag$add, mdgriffith$stylish_elephants$Internal$Flag$yAlign, has)),
								$temp$transform = transform,
								$temp$styles = styles,
								$temp$attrs = attrs,
								$temp$children = children,
								$temp$elementAttrs = remaining;
							classes = $temp$classes;
							node = $temp$node;
							has = $temp$has;
							transform = $temp$transform;
							styles = $temp$styles;
							attrs = $temp$attrs;
							children = $temp$children;
							elementAttrs = $temp$elementAttrs;
							continue gatherAttrRecursive;
						}
				}
			}
		}
	});
var mdgriffith$stylish_elephants$Internal$Model$Untransformed = {$: 0};
var mdgriffith$stylish_elephants$Internal$Model$untransformed = mdgriffith$stylish_elephants$Internal$Model$Untransformed;
var mdgriffith$stylish_elephants$Internal$Model$element = F4(
	function (context, node, attributes, children) {
		return A3(
			mdgriffith$stylish_elephants$Internal$Model$createElement,
			context,
			children,
			A8(
				mdgriffith$stylish_elephants$Internal$Model$gatherAttrRecursive,
				mdgriffith$stylish_elephants$Internal$Model$contextClasses(context),
				node,
				mdgriffith$stylish_elephants$Internal$Flag$none,
				mdgriffith$stylish_elephants$Internal$Model$untransformed,
				_List_Nil,
				_List_Nil,
				_List_Nil,
				elm$core$List$reverse(attributes)));
	});
var mdgriffith$stylish_elephants$Element$el = F2(
	function (attrs, child) {
		return A4(
			mdgriffith$stylish_elephants$Internal$Model$element,
			mdgriffith$stylish_elephants$Internal$Model$asEl,
			mdgriffith$stylish_elephants$Internal$Model$div,
			A2(
				elm$core$List$cons,
				mdgriffith$stylish_elephants$Element$width(mdgriffith$stylish_elephants$Element$shrink),
				A2(
					elm$core$List$cons,
					mdgriffith$stylish_elephants$Element$height(mdgriffith$stylish_elephants$Element$shrink),
					attrs)),
			mdgriffith$stylish_elephants$Internal$Model$Unkeyed(
				_List_fromArray(
					[child])));
	});
var elm$core$Basics$always = F2(
	function (a, _n0) {
		return a;
	});
var mdgriffith$stylish_elephants$Internal$Model$unstyled = A2(elm$core$Basics$composeL, mdgriffith$stylish_elephants$Internal$Model$Unstyled, elm$core$Basics$always);
var mdgriffith$stylish_elephants$Element$html = mdgriffith$stylish_elephants$Internal$Model$unstyled;
var mdgriffith$stylish_elephants$Internal$Flag$padding = mdgriffith$stylish_elephants$Internal$Flag$flag(2);
var mdgriffith$stylish_elephants$Internal$Model$PaddingStyle = F5(
	function (a, b, c, d, e) {
		return {$: 6, a: a, b: b, c: c, d: d, e: e};
	});
var mdgriffith$stylish_elephants$Internal$Model$StyleClass = F2(
	function (a, b) {
		return {$: 4, a: a, b: b};
	});
var mdgriffith$stylish_elephants$Element$padding = function (x) {
	return A2(
		mdgriffith$stylish_elephants$Internal$Model$StyleClass,
		mdgriffith$stylish_elephants$Internal$Flag$padding,
		A5(
			mdgriffith$stylish_elephants$Internal$Model$PaddingStyle,
			'p-' + elm$core$String$fromInt(x),
			x,
			x,
			x,
			x));
};
var mdgriffith$stylish_elephants$Internal$Model$Px = function (a) {
	return {$: 0, a: a};
};
var mdgriffith$stylish_elephants$Element$px = mdgriffith$stylish_elephants$Internal$Model$Px;
var author$project$Main$animationView = function (model) {
	return A2(
		mdgriffith$stylish_elephants$Element$el,
		_List_fromArray(
			[
				mdgriffith$stylish_elephants$Element$padding(20),
				mdgriffith$stylish_elephants$Element$height(mdgriffith$stylish_elephants$Element$shrink),
				mdgriffith$stylish_elephants$Element$alignTop,
				mdgriffith$stylish_elephants$Element$alignLeft,
				mdgriffith$stylish_elephants$Element$width(
				mdgriffith$stylish_elephants$Element$px(100))
			]),
		mdgriffith$stylish_elephants$Element$html(
			A2(
				elm$svg$Svg$svg,
				_List_fromArray(
					[
						elm$svg$Svg$Attributes$version('1.1'),
						elm$svg$Svg$Attributes$x('0'),
						elm$svg$Svg$Attributes$y('0'),
						elm$svg$Svg$Attributes$viewBox('0 0 323.141 322.95'),
						elm$svg$Svg$Attributes$width('100%')
					]),
				_List_fromArray(
					[
						A2(
						elm$svg$Svg$g,
						_List_Nil,
						A2(
							elm$core$List$map,
							function (poly) {
								return A2(
									elm$svg$Svg$polygon,
									author$project$Animation$render(poly),
									_List_Nil);
							},
							model.M))
					]))));
};
var elm$html$Html$i = _VirtualDom_node('i');
var author$project$Page$Home$envelopeIcon = mdgriffith$stylish_elephants$Element$html(
	A2(
		elm$html$Html$i,
		_List_fromArray(
			[
				elm$html$Html$Attributes$class('far fa-envelope')
			]),
		_List_Nil));
var mdgriffith$stylish_elephants$Internal$Flag$fontSize = mdgriffith$stylish_elephants$Internal$Flag$flag(4);
var mdgriffith$stylish_elephants$Internal$Model$FontSize = function (a) {
	return {$: 2, a: a};
};
var mdgriffith$stylish_elephants$Element$Font$size = function (i) {
	return A2(
		mdgriffith$stylish_elephants$Internal$Model$StyleClass,
		mdgriffith$stylish_elephants$Internal$Flag$fontSize,
		mdgriffith$stylish_elephants$Internal$Model$FontSize(i));
};
var author$project$Style$fontSize = {
	ba: mdgriffith$stylish_elephants$Element$Font$size(20),
	cM: mdgriffith$stylish_elephants$Element$Font$size(24),
	cN: mdgriffith$stylish_elephants$Element$Font$size(20),
	c8: mdgriffith$stylish_elephants$Element$Font$size(14),
	bT: mdgriffith$stylish_elephants$Element$Font$size(40)
};
var mdgriffith$stylish_elephants$Internal$Model$Rgba = F4(
	function (a, b, c, d) {
		return {$: 0, a: a, b: b, c: c, d: d};
	});
var mdgriffith$stylish_elephants$Element$rgb = F3(
	function (r, g, b) {
		return A4(mdgriffith$stylish_elephants$Internal$Model$Rgba, r, g, b, 1);
	});
var author$project$Style$elementRgb = F3(
	function (red, green, blue) {
		return A3(mdgriffith$stylish_elephants$Element$rgb, red / 255, green / 255, blue / 255);
	});
var author$project$Style$highlightFactor = 25;
var author$project$Style$highlightRgb = F3(
	function (red, green, blue) {
		return A3(author$project$Style$elementRgb, red + author$project$Style$highlightFactor, green + author$project$Style$highlightFactor, blue + author$project$Style$highlightFactor);
	});
var author$project$Style$hoverPalette = {
	bb: A3(author$project$Style$highlightRgb, 0, 23, 31),
	bp: A3(author$project$Style$highlightRgb, 0, 168, 232),
	cz: A3(author$project$Style$highlightRgb, 0, 52, 89),
	cL: A3(author$project$Style$highlightRgb, 0, 126, 167),
	bu: A3(author$project$Style$highlightRgb, 216, 219, 226),
	aI: A3(author$project$Style$highlightRgb, 255, 255, 255)
};
var author$project$Style$palette = {
	bb: A3(author$project$Style$elementRgb, 0, 23, 31),
	bp: A3(author$project$Style$elementRgb, 0, 168, 232),
	cz: A3(author$project$Style$elementRgb, 0, 52, 89),
	cL: A3(author$project$Style$elementRgb, 0, 126, 167),
	bu: A3(author$project$Style$elementRgb, 216, 219, 226),
	aI: A3(author$project$Style$elementRgb, 255, 255, 255)
};
var mdgriffith$stylish_elephants$Internal$Flag$hover = mdgriffith$stylish_elephants$Internal$Flag$flag(33);
var mdgriffith$stylish_elephants$Internal$Model$Hover = 1;
var mdgriffith$stylish_elephants$Internal$Model$PseudoSelector = F2(
	function (a, b) {
		return {$: 10, a: a, b: b};
	});
var elm$virtual_dom$VirtualDom$mapAttribute = _VirtualDom_mapAttribute;
var mdgriffith$stylish_elephants$Internal$Model$Attr = function (a) {
	return {$: 1, a: a};
};
var mdgriffith$stylish_elephants$Internal$Model$Class = F2(
	function (a, b) {
		return {$: 3, a: a, b: b};
	});
var mdgriffith$stylish_elephants$Internal$Model$Describe = function (a) {
	return {$: 2, a: a};
};
var mdgriffith$stylish_elephants$Internal$Model$Nearby = F2(
	function (a, b) {
		return {$: 9, a: a, b: b};
	});
var mdgriffith$stylish_elephants$Internal$Model$NoAttribute = {$: 0};
var mdgriffith$stylish_elephants$Internal$Model$TransformComponent = F2(
	function (a, b) {
		return {$: 10, a: a, b: b};
	});
var elm$virtual_dom$VirtualDom$map = _VirtualDom_map;
var mdgriffith$stylish_elephants$Internal$Model$Empty = {$: 3};
var mdgriffith$stylish_elephants$Internal$Model$Text = function (a) {
	return {$: 2, a: a};
};
var mdgriffith$stylish_elephants$Internal$Model$map = F2(
	function (fn, el) {
		switch (el.$) {
			case 1:
				var styled = el.a;
				return mdgriffith$stylish_elephants$Internal$Model$Styled(
					{
						cB: F2(
							function (add, context) {
								return A2(
									elm$virtual_dom$VirtualDom$map,
									fn,
									A2(styled.cB, add, context));
							}),
						M: styled.M
					});
			case 0:
				var html = el.a;
				return mdgriffith$stylish_elephants$Internal$Model$Unstyled(
					A2(
						elm$core$Basics$composeL,
						elm$virtual_dom$VirtualDom$map(fn),
						html));
			case 2:
				var str = el.a;
				return mdgriffith$stylish_elephants$Internal$Model$Text(str);
			default:
				return mdgriffith$stylish_elephants$Internal$Model$Empty;
		}
	});
var mdgriffith$stylish_elephants$Internal$Model$mapAttrFromStyle = F2(
	function (fn, attr) {
		switch (attr.$) {
			case 0:
				return mdgriffith$stylish_elephants$Internal$Model$NoAttribute;
			case 2:
				var description = attr.a;
				return mdgriffith$stylish_elephants$Internal$Model$Describe(description);
			case 6:
				var x = attr.a;
				return mdgriffith$stylish_elephants$Internal$Model$AlignX(x);
			case 5:
				var y = attr.a;
				return mdgriffith$stylish_elephants$Internal$Model$AlignY(y);
			case 7:
				var x = attr.a;
				return mdgriffith$stylish_elephants$Internal$Model$Width(x);
			case 8:
				var x = attr.a;
				return mdgriffith$stylish_elephants$Internal$Model$Height(x);
			case 3:
				var x = attr.a;
				var y = attr.b;
				return A2(mdgriffith$stylish_elephants$Internal$Model$Class, x, y);
			case 4:
				var flag = attr.a;
				var style = attr.b;
				return A2(mdgriffith$stylish_elephants$Internal$Model$StyleClass, flag, style);
			case 9:
				var location = attr.a;
				var elem = attr.b;
				return A2(
					mdgriffith$stylish_elephants$Internal$Model$Nearby,
					location,
					A2(mdgriffith$stylish_elephants$Internal$Model$map, fn, elem));
			case 1:
				var htmlAttr = attr.a;
				return mdgriffith$stylish_elephants$Internal$Model$Attr(
					A2(elm$virtual_dom$VirtualDom$mapAttribute, fn, htmlAttr));
			default:
				var fl = attr.a;
				var trans = attr.b;
				return A2(mdgriffith$stylish_elephants$Internal$Model$TransformComponent, fl, trans);
		}
	});
var mdgriffith$stylish_elephants$Internal$Model$removeNever = function (style) {
	return A2(mdgriffith$stylish_elephants$Internal$Model$mapAttrFromStyle, elm$core$Basics$never, style);
};
var mdgriffith$stylish_elephants$Internal$Model$unwrapDecsHelper = F2(
	function (attr, _n0) {
		var styles = _n0.a;
		var trans = _n0.b;
		var _n1 = mdgriffith$stylish_elephants$Internal$Model$removeNever(attr);
		switch (_n1.$) {
			case 4:
				var style = _n1.b;
				return _Utils_Tuple2(
					A2(elm$core$List$cons, style, styles),
					trans);
			case 10:
				var flag = _n1.a;
				var component = _n1.b;
				return _Utils_Tuple2(
					styles,
					A2(mdgriffith$stylish_elephants$Internal$Model$composeTransformation, trans, component));
			default:
				return _Utils_Tuple2(styles, trans);
		}
	});
var mdgriffith$stylish_elephants$Internal$Model$unwrapDecorations = function (attrs) {
	var _n0 = A3(
		elm$core$List$foldl,
		mdgriffith$stylish_elephants$Internal$Model$unwrapDecsHelper,
		_Utils_Tuple2(_List_Nil, mdgriffith$stylish_elephants$Internal$Model$Untransformed),
		attrs);
	var styles = _n0.a;
	var transform = _n0.b;
	return A2(
		elm$core$List$cons,
		mdgriffith$stylish_elephants$Internal$Model$Transform(transform),
		styles);
};
var mdgriffith$stylish_elephants$Element$mouseOver = function (decs) {
	return A2(
		mdgriffith$stylish_elephants$Internal$Model$StyleClass,
		mdgriffith$stylish_elephants$Internal$Flag$hover,
		A2(
			mdgriffith$stylish_elephants$Internal$Model$PseudoSelector,
			1,
			mdgriffith$stylish_elephants$Internal$Model$unwrapDecorations(decs)));
};
var mdgriffith$stylish_elephants$Internal$Model$AsRow = 0;
var mdgriffith$stylish_elephants$Internal$Model$asRow = 0;
var mdgriffith$stylish_elephants$Internal$Model$htmlClass = function (cls) {
	return mdgriffith$stylish_elephants$Internal$Model$Attr(
		elm$html$Html$Attributes$class(cls));
};
var mdgriffith$stylish_elephants$Element$row = F2(
	function (attrs, children) {
		return A4(
			mdgriffith$stylish_elephants$Internal$Model$element,
			mdgriffith$stylish_elephants$Internal$Model$asRow,
			mdgriffith$stylish_elephants$Internal$Model$div,
			A2(
				elm$core$List$cons,
				mdgriffith$stylish_elephants$Internal$Model$htmlClass(mdgriffith$stylish_elephants$Internal$Style$classes.bg),
				A2(
					elm$core$List$cons,
					mdgriffith$stylish_elephants$Internal$Model$htmlClass(mdgriffith$stylish_elephants$Internal$Style$classes.ai),
					A2(
						elm$core$List$cons,
						mdgriffith$stylish_elephants$Element$width(mdgriffith$stylish_elephants$Element$shrink),
						A2(
							elm$core$List$cons,
							mdgriffith$stylish_elephants$Element$height(mdgriffith$stylish_elephants$Element$shrink),
							attrs)))),
			mdgriffith$stylish_elephants$Internal$Model$Unkeyed(children));
	});
var mdgriffith$stylish_elephants$Internal$Flag$spacing = mdgriffith$stylish_elephants$Internal$Flag$flag(3);
var mdgriffith$stylish_elephants$Internal$Model$SpacingStyle = F3(
	function (a, b, c) {
		return {$: 5, a: a, b: b, c: c};
	});
var mdgriffith$stylish_elephants$Internal$Model$spacingName = F2(
	function (x, y) {
		return 'spacing-' + (elm$core$String$fromInt(x) + ('-' + elm$core$String$fromInt(y)));
	});
var mdgriffith$stylish_elephants$Element$spacing = function (x) {
	return A2(
		mdgriffith$stylish_elephants$Internal$Model$StyleClass,
		mdgriffith$stylish_elephants$Internal$Flag$spacing,
		A3(
			mdgriffith$stylish_elephants$Internal$Model$SpacingStyle,
			A2(mdgriffith$stylish_elephants$Internal$Model$spacingName, x, x),
			x,
			x));
};
var mdgriffith$stylish_elephants$Internal$Flag$bgColor = mdgriffith$stylish_elephants$Internal$Flag$flag(8);
var mdgriffith$stylish_elephants$Internal$Model$Colored = F3(
	function (a, b, c) {
		return {$: 4, a: a, b: b, c: c};
	});
var mdgriffith$stylish_elephants$Internal$Model$formatColorClass = function (_n0) {
	var red = _n0.a;
	var green = _n0.b;
	var blue = _n0.c;
	var alpha = _n0.d;
	return mdgriffith$stylish_elephants$Internal$Model$floatClass(red) + ('-' + (mdgriffith$stylish_elephants$Internal$Model$floatClass(green) + ('-' + (mdgriffith$stylish_elephants$Internal$Model$floatClass(blue) + ('-' + mdgriffith$stylish_elephants$Internal$Model$floatClass(alpha))))));
};
var mdgriffith$stylish_elephants$Element$Background$color = function (clr) {
	return A2(
		mdgriffith$stylish_elephants$Internal$Model$StyleClass,
		mdgriffith$stylish_elephants$Internal$Flag$bgColor,
		A3(
			mdgriffith$stylish_elephants$Internal$Model$Colored,
			'bg-' + mdgriffith$stylish_elephants$Internal$Model$formatColorClass(clr),
			'background-color',
			clr));
};
var mdgriffith$stylish_elephants$Internal$Flag$borderRound = mdgriffith$stylish_elephants$Internal$Flag$flag(17);
var mdgriffith$stylish_elephants$Element$Border$rounded = function (radius) {
	return A2(
		mdgriffith$stylish_elephants$Internal$Model$StyleClass,
		mdgriffith$stylish_elephants$Internal$Flag$borderRound,
		A3(
			mdgriffith$stylish_elephants$Internal$Model$Single,
			'border-radius-' + elm$core$String$fromInt(radius),
			'border-radius',
			elm$core$String$fromInt(radius) + 'px'));
};
var mdgriffith$stylish_elephants$Internal$Flag$fontColor = mdgriffith$stylish_elephants$Internal$Flag$flag(14);
var mdgriffith$stylish_elephants$Element$Font$color = function (fontColor) {
	return A2(
		mdgriffith$stylish_elephants$Internal$Model$StyleClass,
		mdgriffith$stylish_elephants$Internal$Flag$fontColor,
		A3(
			mdgriffith$stylish_elephants$Internal$Model$Colored,
			'fc-' + mdgriffith$stylish_elephants$Internal$Model$formatColorClass(fontColor),
			'color',
			fontColor));
};
var author$project$Style$Helpers$button = F2(
	function (_n0, children) {
		var fontColor = _n0.an;
		var backgroundColor = _n0.ag;
		var size = _n0.x;
		return A2(
			mdgriffith$stylish_elephants$Element$row,
			_List_fromArray(
				[
					mdgriffith$stylish_elephants$Element$spacing(20),
					mdgriffith$stylish_elephants$Element$Font$color(
					fontColor(author$project$Style$palette)),
					mdgriffith$stylish_elephants$Element$mouseOver(
					_List_fromArray(
						[
							mdgriffith$stylish_elephants$Element$Background$color(
							backgroundColor(author$project$Style$hoverPalette))
						])),
					mdgriffith$stylish_elephants$Element$Background$color(
					backgroundColor(author$project$Style$palette)),
					mdgriffith$stylish_elephants$Element$padding(15),
					mdgriffith$stylish_elephants$Element$Border$rounded(10),
					author$project$Style$fontSize.ba,
					size
				]),
			children);
	});
var mdgriffith$stylish_elephants$Internal$Model$CenterX = 1;
var mdgriffith$stylish_elephants$Element$centerX = mdgriffith$stylish_elephants$Internal$Model$AlignX(1);
var elm$html$Html$Attributes$href = function (url) {
	return A2(
		elm$html$Html$Attributes$stringProperty,
		'href',
		_VirtualDom_noJavaScriptUri(url));
};
var elm$html$Html$Attributes$rel = _VirtualDom_attribute('rel');
var mdgriffith$stylish_elephants$Element$link = F2(
	function (attrs, _n0) {
		var url = _n0.bV;
		var label = _n0.bt;
		return A4(
			mdgriffith$stylish_elephants$Internal$Model$element,
			mdgriffith$stylish_elephants$Internal$Model$asEl,
			mdgriffith$stylish_elephants$Internal$Model$NodeName('a'),
			A2(
				elm$core$List$cons,
				mdgriffith$stylish_elephants$Internal$Model$Attr(
					elm$html$Html$Attributes$href(url)),
				A2(
					elm$core$List$cons,
					mdgriffith$stylish_elephants$Internal$Model$Attr(
						elm$html$Html$Attributes$rel('noopener noreferrer')),
					A2(
						elm$core$List$cons,
						mdgriffith$stylish_elephants$Element$width(mdgriffith$stylish_elephants$Element$shrink),
						A2(
							elm$core$List$cons,
							mdgriffith$stylish_elephants$Element$height(mdgriffith$stylish_elephants$Element$shrink),
							A2(
								elm$core$List$cons,
								mdgriffith$stylish_elephants$Internal$Model$htmlClass(mdgriffith$stylish_elephants$Internal$Style$classes.aF + (' ' + mdgriffith$stylish_elephants$Internal$Style$classes.ai)),
								attrs))))),
			mdgriffith$stylish_elephants$Internal$Model$Unkeyed(
				_List_fromArray(
					[label])));
	});
var mdgriffith$stylish_elephants$Element$text = function (content) {
	return mdgriffith$stylish_elephants$Internal$Model$Text(content);
};
var author$project$Page$Home$contactButton = A2(
	mdgriffith$stylish_elephants$Element$link,
	_List_fromArray(
		[mdgriffith$stylish_elephants$Element$centerX]),
	{
		bt: A2(
			author$project$Style$Helpers$button,
			{
				ag: function ($) {
					return $.bb;
				},
				an: function ($) {
					return $.aI;
				},
				x: author$project$Style$fontSize.ba
			},
			_List_fromArray(
				[
					A2(mdgriffith$stylish_elephants$Element$el, _List_Nil, author$project$Page$Home$envelopeIcon),
					mdgriffith$stylish_elephants$Element$text('info@incrementalelm.com')
				])),
		bV: 'mailto:info@incrementalelm.com'
	});
var mdgriffith$stylish_elephants$Internal$Model$Fill = function (a) {
	return {$: 2, a: a};
};
var mdgriffith$stylish_elephants$Element$fill = mdgriffith$stylish_elephants$Internal$Model$Fill(1);
var mdgriffith$stylish_elephants$Element$paragraph = F2(
	function (attrs, children) {
		return A4(
			mdgriffith$stylish_elephants$Internal$Model$element,
			mdgriffith$stylish_elephants$Internal$Model$asParagraph,
			mdgriffith$stylish_elephants$Internal$Model$NodeName('p'),
			A2(
				elm$core$List$cons,
				mdgriffith$stylish_elephants$Element$width(mdgriffith$stylish_elephants$Element$fill),
				A2(
					elm$core$List$cons,
					mdgriffith$stylish_elephants$Element$spacing(5),
					attrs)),
			mdgriffith$stylish_elephants$Internal$Model$Unkeyed(children));
	});
var author$project$Page$Home$wrappedText = function (contents) {
	return A2(
		mdgriffith$stylish_elephants$Element$paragraph,
		_List_Nil,
		_List_fromArray(
			[
				mdgriffith$stylish_elephants$Element$text(contents)
			]));
};
var mdgriffith$stylish_elephants$Internal$Flag$fontFamily = mdgriffith$stylish_elephants$Internal$Flag$flag(5);
var mdgriffith$stylish_elephants$Internal$Model$FontFamily = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var elm$core$String$toLower = _String_toLower;
var elm$core$String$words = _String_words;
var mdgriffith$stylish_elephants$Internal$Model$renderFontClassName = F2(
	function (font, current) {
		return _Utils_ap(
			current,
			function () {
				switch (font.$) {
					case 0:
						return 'serif';
					case 1:
						return 'sans-serif';
					case 2:
						return 'monospace';
					case 3:
						var name = font.a;
						return A2(
							elm$core$String$join,
							'-',
							elm$core$String$words(
								elm$core$String$toLower(name)));
					default:
						var name = font.a;
						var url = font.b;
						return A2(
							elm$core$String$join,
							'-',
							elm$core$String$words(
								elm$core$String$toLower(name)));
				}
			}());
	});
var mdgriffith$stylish_elephants$Element$Font$family = function (families) {
	return A2(
		mdgriffith$stylish_elephants$Internal$Model$StyleClass,
		mdgriffith$stylish_elephants$Internal$Flag$fontFamily,
		A2(
			mdgriffith$stylish_elephants$Internal$Model$FontFamily,
			A3(elm$core$List$foldl, mdgriffith$stylish_elephants$Internal$Model$renderFontClassName, 'ff-', families),
			families));
};
var mdgriffith$stylish_elephants$Internal$Model$Typeface = function (a) {
	return {$: 3, a: a};
};
var mdgriffith$stylish_elephants$Element$Font$typeface = mdgriffith$stylish_elephants$Internal$Model$Typeface;
var author$project$Style$fonts = {
	ba: mdgriffith$stylish_elephants$Element$Font$family(
		_List_fromArray(
			[
				mdgriffith$stylish_elephants$Element$Font$typeface('Raleway')
			])),
	bT: mdgriffith$stylish_elephants$Element$Font$family(
		_List_fromArray(
			[
				mdgriffith$stylish_elephants$Element$Font$typeface('Open Sans')
			]))
};
var mdgriffith$stylish_elephants$Internal$Model$AsColumn = 1;
var mdgriffith$stylish_elephants$Internal$Model$asColumn = 1;
var mdgriffith$stylish_elephants$Element$column = F2(
	function (attrs, children) {
		return A4(
			mdgriffith$stylish_elephants$Internal$Model$element,
			mdgriffith$stylish_elephants$Internal$Model$asColumn,
			mdgriffith$stylish_elephants$Internal$Model$div,
			A2(
				elm$core$List$cons,
				mdgriffith$stylish_elephants$Internal$Model$htmlClass(mdgriffith$stylish_elephants$Internal$Style$classes.cm + (' ' + mdgriffith$stylish_elephants$Internal$Style$classes.bg)),
				A2(
					elm$core$List$cons,
					mdgriffith$stylish_elephants$Element$height(mdgriffith$stylish_elephants$Element$shrink),
					A2(
						elm$core$List$cons,
						mdgriffith$stylish_elephants$Element$width(mdgriffith$stylish_elephants$Element$shrink),
						attrs))),
			mdgriffith$stylish_elephants$Internal$Model$Unkeyed(children));
	});
var mdgriffith$stylish_elephants$Internal$Model$Min = F2(
	function (a, b) {
		return {$: 3, a: a, b: b};
	});
var mdgriffith$stylish_elephants$Element$minimum = F2(
	function (i, l) {
		return A2(mdgriffith$stylish_elephants$Internal$Model$Min, i, l);
	});
var mdgriffith$stylish_elephants$Internal$Flag$fontAlignment = mdgriffith$stylish_elephants$Internal$Flag$flag(12);
var mdgriffith$stylish_elephants$Element$Font$center = A2(mdgriffith$stylish_elephants$Internal$Model$Class, mdgriffith$stylish_elephants$Internal$Flag$fontAlignment, mdgriffith$stylish_elephants$Internal$Style$classes.dg);
var author$project$Page$Home$contactSection = A2(
	mdgriffith$stylish_elephants$Element$column,
	_List_fromArray(
		[
			mdgriffith$stylish_elephants$Element$Background$color(author$project$Style$palette.bp),
			mdgriffith$stylish_elephants$Element$height(
			A2(mdgriffith$stylish_elephants$Element$minimum, 300, mdgriffith$stylish_elephants$Element$shrink)),
			mdgriffith$stylish_elephants$Element$width(mdgriffith$stylish_elephants$Element$fill)
		]),
	_List_fromArray(
		[
			A2(
			mdgriffith$stylish_elephants$Element$el,
			_List_fromArray(
				[
					mdgriffith$stylish_elephants$Element$Font$color(author$project$Style$palette.bb),
					mdgriffith$stylish_elephants$Element$centerX,
					author$project$Style$fontSize.bT,
					author$project$Style$fonts.ba,
					mdgriffith$stylish_elephants$Element$padding(30)
				]),
			A2(
				mdgriffith$stylish_elephants$Element$el,
				_List_fromArray(
					[
						author$project$Style$fonts.bT,
						mdgriffith$stylish_elephants$Element$centerX,
						mdgriffith$stylish_elephants$Element$Font$center,
						mdgriffith$stylish_elephants$Element$Font$color(author$project$Style$palette.aI)
					]),
				author$project$Page$Home$wrappedText('Get in touch'))),
			author$project$Page$Home$contactButton
		]));
var author$project$Page$Home$bulletPoint = function (content) {
	return A2(
		mdgriffith$stylish_elephants$Element$el,
		_List_fromArray(
			[author$project$Style$fonts.ba, author$project$Style$fontSize.ba]),
		author$project$Page$Home$wrappedText('→ ' + content));
};
var author$project$Page$Home$elementRgb = F3(
	function (red, green, blue) {
		return A3(mdgriffith$stylish_elephants$Element$rgb, red / 255, green / 255, blue / 255);
	});
var author$project$Page$Home$white = A3(author$project$Page$Home$elementRgb, 255, 255, 255);
var mdgriffith$stylish_elephants$Internal$Model$CenterY = 1;
var mdgriffith$stylish_elephants$Element$centerY = mdgriffith$stylish_elephants$Internal$Model$AlignY(1);
var mdgriffith$stylish_elephants$Internal$Model$InFront = 4;
var mdgriffith$stylish_elephants$Element$inFront = function (element) {
	return A2(mdgriffith$stylish_elephants$Internal$Model$Nearby, 4, element);
};
var mdgriffith$stylish_elephants$Element$none = mdgriffith$stylish_elephants$Internal$Model$Empty;
var mdgriffith$stylish_elephants$Internal$Flag$fontWeight = mdgriffith$stylish_elephants$Internal$Flag$flag(13);
var mdgriffith$stylish_elephants$Element$Font$bold = A2(mdgriffith$stylish_elephants$Internal$Model$Class, mdgriffith$stylish_elephants$Internal$Flag$fontWeight, mdgriffith$stylish_elephants$Internal$Style$classes.bb);
var author$project$Page$Home$iterationBubble = function (iterationNumber) {
	return A2(
		mdgriffith$stylish_elephants$Element$el,
		_List_fromArray(
			[mdgriffith$stylish_elephants$Element$centerX]),
		A2(
			mdgriffith$stylish_elephants$Element$el,
			_List_fromArray(
				[
					mdgriffith$stylish_elephants$Element$Background$color(author$project$Style$palette.bp),
					mdgriffith$stylish_elephants$Element$padding(80),
					mdgriffith$stylish_elephants$Element$Border$rounded(10000),
					mdgriffith$stylish_elephants$Element$inFront(
					A2(
						mdgriffith$stylish_elephants$Element$paragraph,
						_List_fromArray(
							[
								mdgriffith$stylish_elephants$Element$Font$color(author$project$Page$Home$white),
								author$project$Style$fonts.bT,
								mdgriffith$stylish_elephants$Element$centerX,
								mdgriffith$stylish_elephants$Element$centerY,
								mdgriffith$stylish_elephants$Element$Font$center,
								author$project$Style$fontSize.cN,
								mdgriffith$stylish_elephants$Element$Font$bold
							]),
						_List_fromArray(
							[
								mdgriffith$stylish_elephants$Element$text('Iteration '),
								mdgriffith$stylish_elephants$Element$text(
								elm$core$String$fromInt(iterationNumber))
							])))
				]),
			mdgriffith$stylish_elephants$Element$none));
};
var author$project$Page$Home$iteration = F2(
	function (iterationNumber, bulletPoints) {
		return A2(
			mdgriffith$stylish_elephants$Element$column,
			_List_fromArray(
				[
					mdgriffith$stylish_elephants$Element$spacing(50),
					mdgriffith$stylish_elephants$Element$alignTop,
					mdgriffith$stylish_elephants$Element$width(mdgriffith$stylish_elephants$Element$fill)
				]),
			_List_fromArray(
				[
					author$project$Page$Home$iterationBubble(iterationNumber),
					A2(
					mdgriffith$stylish_elephants$Element$column,
					_List_fromArray(
						[
							mdgriffith$stylish_elephants$Element$centerX,
							mdgriffith$stylish_elephants$Element$spacing(30)
						]),
					A2(elm$core$List$map, author$project$Page$Home$bulletPoint, bulletPoints))
				]));
	});
var mdgriffith$stylish_elephants$Element$spaceEvenly = A2(
	mdgriffith$stylish_elephants$Internal$Model$Class,
	mdgriffith$stylish_elephants$Internal$Flag$xAlign,
	function ($) {
		return $.c9;
	}(mdgriffith$stylish_elephants$Internal$Style$classes));
var author$project$Page$Home$iterations = function (dimensions) {
	return ((dimensions.D > 1000) ? mdgriffith$stylish_elephants$Element$row(
		_List_fromArray(
			[
				mdgriffith$stylish_elephants$Element$spaceEvenly,
				mdgriffith$stylish_elephants$Element$width(mdgriffith$stylish_elephants$Element$fill),
				mdgriffith$stylish_elephants$Element$padding(50)
			])) : mdgriffith$stylish_elephants$Element$column(
		_List_fromArray(
			[
				mdgriffith$stylish_elephants$Element$width(mdgriffith$stylish_elephants$Element$fill),
				mdgriffith$stylish_elephants$Element$padding(20)
			])))(
		_List_fromArray(
			[
				A2(
				author$project$Page$Home$iteration,
				0,
				_List_fromArray(
					['Elm Fundamentals training for your team', 'Ship Elm code to production in under a week', 'Master The Elm Architecture', 'Fundamentals of Test-Driven Development in Elm'])),
				A2(
				author$project$Page$Home$iteration,
				1,
				_List_fromArray(
					['Reuse and scaling patterns', 'Advanced JavaScript interop techniques', 'Choose the right Elm styling approach for your environment'])),
				A2(
				author$project$Page$Home$iteration,
				2,
				_List_fromArray(
					['Transition your codebase to a full Single-Page Elm App', 'Master Elm architectural patterns']))
			]));
};
var author$project$Page$Home$servicesSection = function (dimensions) {
	return A2(
		mdgriffith$stylish_elephants$Element$column,
		_List_fromArray(
			[
				mdgriffith$stylish_elephants$Element$Background$color(author$project$Style$palette.bu),
				mdgriffith$stylish_elephants$Element$height(
				A2(mdgriffith$stylish_elephants$Element$minimum, 300, mdgriffith$stylish_elephants$Element$shrink)),
				mdgriffith$stylish_elephants$Element$width(mdgriffith$stylish_elephants$Element$fill)
			]),
		_List_fromArray(
			[
				A2(
				mdgriffith$stylish_elephants$Element$column,
				_List_fromArray(
					[
						mdgriffith$stylish_elephants$Element$Font$color(author$project$Style$palette.bb),
						mdgriffith$stylish_elephants$Element$centerY,
						mdgriffith$stylish_elephants$Element$width(mdgriffith$stylish_elephants$Element$fill),
						author$project$Style$fontSize.bT,
						author$project$Style$fonts.ba,
						mdgriffith$stylish_elephants$Element$spacing(25),
						mdgriffith$stylish_elephants$Element$padding(30)
					]),
				_List_fromArray(
					[
						A2(
						mdgriffith$stylish_elephants$Element$el,
						_List_fromArray(
							[author$project$Style$fonts.bT, mdgriffith$stylish_elephants$Element$centerX, mdgriffith$stylish_elephants$Element$Font$center]),
						author$project$Page$Home$wrappedText('Services')),
						author$project$Page$Home$iterations(dimensions)
					]))
			]));
};
var author$project$Page$Home$bulletSection = function (_n0) {
	var backgroundColor = _n0.ag;
	var fontColor = _n0.an;
	var headingText = _n0.aX;
	var bulletContents = _n0.aT;
	var append = _n0.aS;
	return A2(
		mdgriffith$stylish_elephants$Element$column,
		_List_fromArray(
			[
				mdgriffith$stylish_elephants$Element$Background$color(backgroundColor),
				mdgriffith$stylish_elephants$Element$height(
				A2(mdgriffith$stylish_elephants$Element$minimum, 300, mdgriffith$stylish_elephants$Element$shrink)),
				mdgriffith$stylish_elephants$Element$width(mdgriffith$stylish_elephants$Element$fill)
			]),
		_List_fromArray(
			[
				A2(
				mdgriffith$stylish_elephants$Element$column,
				_List_fromArray(
					[
						mdgriffith$stylish_elephants$Element$Font$color(fontColor),
						mdgriffith$stylish_elephants$Element$centerY,
						mdgriffith$stylish_elephants$Element$width(mdgriffith$stylish_elephants$Element$fill),
						author$project$Style$fontSize.bT,
						author$project$Style$fonts.ba,
						mdgriffith$stylish_elephants$Element$spacing(25),
						mdgriffith$stylish_elephants$Element$padding(30)
					]),
				elm$core$List$concat(
					_List_fromArray(
						[
							_List_fromArray(
							[
								A2(
								mdgriffith$stylish_elephants$Element$el,
								_List_fromArray(
									[author$project$Style$fonts.bT, mdgriffith$stylish_elephants$Element$centerX, mdgriffith$stylish_elephants$Element$Font$center]),
								author$project$Page$Home$wrappedText(headingText))
							]),
							A2(elm$core$List$map, author$project$Page$Home$bulletPoint, bulletContents),
							_List_fromArray(
							[append])
						])))
			]));
};
var author$project$Page$Home$whyElmSection = author$project$Page$Home$bulletSection(
	{
		aS: A2(
			mdgriffith$stylish_elephants$Element$link,
			_List_fromArray(
				[mdgriffith$stylish_elephants$Element$centerX]),
			{
				bt: A2(
					author$project$Style$Helpers$button,
					{
						ag: function ($) {
							return $.cL;
						},
						an: function ($) {
							return $.aI;
						},
						x: author$project$Style$fontSize.c8
					},
					_List_fromArray(
						[
							author$project$Page$Home$wrappedText('Read About Why Elm?')
						])),
				bV: '/#why-elm'
			}),
		ag: author$project$Style$palette.cz,
		aT: _List_fromArray(
			['Zero runtime exceptions', 'Rely on language guarantees instead of discipline', 'Predictable code - no globals or hidden side-effects']),
		an: A3(mdgriffith$stylish_elephants$Element$rgb, 255, 255, 255),
		aX: 'Want a highly reliable & maintainable frontend?'
	});
var author$project$Page$Home$whyIncrementalSection = author$project$Page$Home$bulletSection(
	{
		aS: mdgriffith$stylish_elephants$Element$none,
		ag: author$project$Style$palette.aI,
		aT: _List_fromArray(
			['One tiny step at a time!', 'See how Elm fits in your environment: learn the fundamentals and ship something in less than a week!', 'Elm is all about reliability. Incremental Elm Consulting gets you there reliably']),
		an: author$project$Style$palette.bb,
		aX: 'How do I start?'
	});
var author$project$Page$Home$view = function (dimensions) {
	return _List_fromArray(
		[
			author$project$Page$Home$whyElmSection,
			author$project$Page$Home$whyIncrementalSection,
			author$project$Page$Home$servicesSection(dimensions),
			author$project$Page$Home$contactSection
		]);
};
var mdgriffith$stylish_elephants$Internal$Model$Right = 2;
var mdgriffith$stylish_elephants$Element$alignRight = mdgriffith$stylish_elephants$Internal$Model$AlignX(2);
var author$project$View$Navbar$logoText = A2(
	mdgriffith$stylish_elephants$Element$column,
	_List_fromArray(
		[
			author$project$Style$fonts.bT,
			mdgriffith$stylish_elephants$Element$width(mdgriffith$stylish_elephants$Element$shrink),
			mdgriffith$stylish_elephants$Element$height(mdgriffith$stylish_elephants$Element$shrink),
			mdgriffith$stylish_elephants$Element$spacing(5)
		]),
	_List_fromArray(
		[
			A2(
			mdgriffith$stylish_elephants$Element$el,
			_List_fromArray(
				[
					mdgriffith$stylish_elephants$Element$Font$color(author$project$Style$palette.bb),
					author$project$Style$fontSize.cM
				]),
			mdgriffith$stylish_elephants$Element$text('Incremental Elm')),
			A2(
			mdgriffith$stylish_elephants$Element$el,
			_List_fromArray(
				[
					mdgriffith$stylish_elephants$Element$Font$color(author$project$Style$palette.bb),
					author$project$Style$fontSize.c8,
					mdgriffith$stylish_elephants$Element$alignRight
				]),
			mdgriffith$stylish_elephants$Element$text('Consulting'))
		]));
var author$project$View$Navbar$view = F2(
	function (model, animationView) {
		return A2(
			mdgriffith$stylish_elephants$Element$link,
			_List_Nil,
			{
				bt: A2(
					mdgriffith$stylish_elephants$Element$row,
					_List_fromArray(
						[
							mdgriffith$stylish_elephants$Element$Background$color(author$project$Style$palette.aI),
							mdgriffith$stylish_elephants$Element$alignTop
						]),
					_List_fromArray(
						[
							animationView(model),
							author$project$View$Navbar$logoText
						])),
				bV: '/'
			});
	});
var mdgriffith$stylish_elephants$Internal$Model$OnlyDynamic = F2(
	function (a, b) {
		return {$: 2, a: a, b: b};
	});
var mdgriffith$stylish_elephants$Internal$Model$StaticRootAndDynamic = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var mdgriffith$stylish_elephants$Internal$Model$AllowHover = 1;
var mdgriffith$stylish_elephants$Internal$Model$Layout = 1;
var mdgriffith$stylish_elephants$Internal$Model$focusDefaultStyle = {
	ag: elm$core$Maybe$Nothing,
	ca: elm$core$Maybe$Nothing,
	c6: elm$core$Maybe$Just(
		{
			s: 3,
			d: A4(mdgriffith$stylish_elephants$Internal$Model$Rgba, 155 / 255, 203 / 255, 1, 1),
			bw: _Utils_Tuple2(0, 0),
			x: 3
		})
};
var mdgriffith$stylish_elephants$Internal$Model$optionsToRecord = function (options) {
	var combine = F2(
		function (opt, record) {
			switch (opt.$) {
				case 0:
					var hoverable = opt.a;
					var _n4 = record.cA;
					if (_n4.$ === 1) {
						return _Utils_update(
							record,
							{
								cA: elm$core$Maybe$Just(hoverable)
							});
					} else {
						return record;
					}
				case 1:
					var focusStyle = opt.a;
					var _n5 = record.cv;
					if (_n5.$ === 1) {
						return _Utils_update(
							record,
							{
								cv: elm$core$Maybe$Just(focusStyle)
							});
					} else {
						return record;
					}
				default:
					var renderMode = opt.a;
					var _n6 = record.cO;
					if (_n6.$ === 1) {
						return _Utils_update(
							record,
							{
								cO: elm$core$Maybe$Just(renderMode)
							});
					} else {
						return record;
					}
			}
		});
	var andFinally = function (record) {
		return {
			cv: function () {
				var _n0 = record.cv;
				if (_n0.$ === 1) {
					return mdgriffith$stylish_elephants$Internal$Model$focusDefaultStyle;
				} else {
					var focusable = _n0.a;
					return focusable;
				}
			}(),
			cA: function () {
				var _n1 = record.cA;
				if (_n1.$ === 1) {
					return 1;
				} else {
					var hoverable = _n1.a;
					return hoverable;
				}
			}(),
			cO: function () {
				var _n2 = record.cO;
				if (_n2.$ === 1) {
					return 1;
				} else {
					var actualMode = _n2.a;
					return actualMode;
				}
			}()
		};
	};
	return andFinally(
		A3(
			elm$core$List$foldr,
			combine,
			{cv: elm$core$Maybe$Nothing, cA: elm$core$Maybe$Nothing, cO: elm$core$Maybe$Nothing},
			options));
};
var mdgriffith$stylish_elephants$Internal$Model$toHtml = F2(
	function (mode, el) {
		switch (el.$) {
			case 0:
				var html = el.a;
				return html(mdgriffith$stylish_elephants$Internal$Model$asEl);
			case 1:
				var styles = el.a.M;
				var html = el.a.cB;
				return A2(
					html,
					mode(styles),
					mdgriffith$stylish_elephants$Internal$Model$asEl);
			case 2:
				var text = el.a;
				return mdgriffith$stylish_elephants$Internal$Model$textElement(text);
			default:
				return mdgriffith$stylish_elephants$Internal$Model$textElement('');
		}
	});
var mdgriffith$stylish_elephants$Internal$Model$renderRoot = F3(
	function (optionList, attributes, child) {
		var options = mdgriffith$stylish_elephants$Internal$Model$optionsToRecord(optionList);
		var embedStyle = function () {
			var _n0 = options.cO;
			if (_n0 === 2) {
				return mdgriffith$stylish_elephants$Internal$Model$OnlyDynamic(options);
			} else {
				return mdgriffith$stylish_elephants$Internal$Model$StaticRootAndDynamic(options);
			}
		}();
		return A2(
			mdgriffith$stylish_elephants$Internal$Model$toHtml,
			embedStyle,
			A4(
				mdgriffith$stylish_elephants$Internal$Model$element,
				mdgriffith$stylish_elephants$Internal$Model$asEl,
				mdgriffith$stylish_elephants$Internal$Model$div,
				attributes,
				mdgriffith$stylish_elephants$Internal$Model$Unkeyed(
					_List_fromArray(
						[child]))));
	});
var mdgriffith$stylish_elephants$Internal$Model$SansSerif = {$: 1};
var mdgriffith$stylish_elephants$Internal$Model$rootStyle = function () {
	var families = _List_fromArray(
		[
			mdgriffith$stylish_elephants$Internal$Model$Typeface('Open Sans'),
			mdgriffith$stylish_elephants$Internal$Model$Typeface('Helvetica'),
			mdgriffith$stylish_elephants$Internal$Model$Typeface('Verdana'),
			mdgriffith$stylish_elephants$Internal$Model$SansSerif
		]);
	return _List_fromArray(
		[
			A2(
			mdgriffith$stylish_elephants$Internal$Model$StyleClass,
			mdgriffith$stylish_elephants$Internal$Flag$bgColor,
			A3(
				mdgriffith$stylish_elephants$Internal$Model$Colored,
				'bg-color-' + mdgriffith$stylish_elephants$Internal$Model$formatColorClass(
					A4(mdgriffith$stylish_elephants$Internal$Model$Rgba, 1, 1, 1, 1)),
				'background-color',
				A4(mdgriffith$stylish_elephants$Internal$Model$Rgba, 1, 1, 1, 1))),
			A2(
			mdgriffith$stylish_elephants$Internal$Model$StyleClass,
			mdgriffith$stylish_elephants$Internal$Flag$fontColor,
			A3(
				mdgriffith$stylish_elephants$Internal$Model$Colored,
				'font-color-' + mdgriffith$stylish_elephants$Internal$Model$formatColorClass(
					A4(mdgriffith$stylish_elephants$Internal$Model$Rgba, 0, 0, 0, 1)),
				'color',
				A4(mdgriffith$stylish_elephants$Internal$Model$Rgba, 0, 0, 0, 1))),
			A2(
			mdgriffith$stylish_elephants$Internal$Model$StyleClass,
			mdgriffith$stylish_elephants$Internal$Flag$fontSize,
			A3(mdgriffith$stylish_elephants$Internal$Model$Single, 'font-size-20', 'font-size', '20px')),
			A2(
			mdgriffith$stylish_elephants$Internal$Model$StyleClass,
			mdgriffith$stylish_elephants$Internal$Flag$fontFamily,
			A2(
				mdgriffith$stylish_elephants$Internal$Model$FontFamily,
				A3(elm$core$List$foldl, mdgriffith$stylish_elephants$Internal$Model$renderFontClassName, 'font-', families),
				families))
		]);
}();
var mdgriffith$stylish_elephants$Element$layoutWith = F3(
	function (_n0, attrs, child) {
		var options = _n0.bx;
		return A3(
			mdgriffith$stylish_elephants$Internal$Model$renderRoot,
			options,
			A2(
				elm$core$List$cons,
				mdgriffith$stylish_elephants$Internal$Model$htmlClass(
					A2(
						elm$core$String$join,
						' ',
						_List_fromArray(
							[mdgriffith$stylish_elephants$Internal$Style$classes.c0, mdgriffith$stylish_elephants$Internal$Style$classes.b6, mdgriffith$stylish_elephants$Internal$Style$classes.c7]))),
				_Utils_ap(mdgriffith$stylish_elephants$Internal$Model$rootStyle, attrs)),
			child);
	});
var mdgriffith$stylish_elephants$Element$layout = mdgriffith$stylish_elephants$Element$layoutWith(
	{bx: _List_Nil});
var author$project$Main$mainView = function (model) {
	var page = model.aq;
	if (page === 1) {
		return A2(
			mdgriffith$stylish_elephants$Element$layout,
			_List_Nil,
			A2(
				mdgriffith$stylish_elephants$Element$column,
				_List_fromArray(
					[
						mdgriffith$stylish_elephants$Element$height(mdgriffith$stylish_elephants$Element$shrink),
						mdgriffith$stylish_elephants$Element$alignTop,
						mdgriffith$stylish_elephants$Element$width(mdgriffith$stylish_elephants$Element$fill)
					]),
				_List_fromArray(
					[
						A2(author$project$View$Navbar$view, model, author$project$Main$animationView),
						mdgriffith$stylish_elephants$Element$text('Why Elm Contents...')
					])));
	} else {
		return A2(
			mdgriffith$stylish_elephants$Element$layout,
			_List_Nil,
			A2(
				mdgriffith$stylish_elephants$Element$column,
				_List_fromArray(
					[
						mdgriffith$stylish_elephants$Element$height(mdgriffith$stylish_elephants$Element$shrink),
						mdgriffith$stylish_elephants$Element$alignTop,
						mdgriffith$stylish_elephants$Element$width(mdgriffith$stylish_elephants$Element$fill)
					]),
				A2(
					elm$core$List$cons,
					A2(author$project$View$Navbar$view, model, author$project$Main$animationView),
					author$project$Page$Home$view(model._))));
	}
};
var author$project$Main$view = function (model) {
	var page = model.aq;
	if (!page) {
		return {
			ba: _List_fromArray(
				[
					author$project$Main$mainView(model)
				]),
			bT: 'Incremental Elm Consulting'
		};
	} else {
		return {
			ba: _List_fromArray(
				[
					author$project$Main$mainView(model)
				]),
			bT: 'Incremental Elm - Why Elm?'
		};
	}
};
var elm$browser$Browser$application = _Browser_application;
var author$project$Main$main = elm$browser$Browser$application(
	{cF: author$project$Main$init, cU: author$project$Main$UrlChanged, cV: author$project$Main$UrlRequest, de: author$project$Main$subscriptions, dy: author$project$Main$update, dA: author$project$Main$view});
_Platform_export({'Main':{'init':author$project$Main$main(
	elm$json$Json$Decode$succeed(0))(0)}});}(this));