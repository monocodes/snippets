---
title: js
categories:
  - software
  - guides
  - notes
  - code
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [built-in operators](#built-in-operators)
  - [typeof](#typeof)
  - [let, const](#let-const)
- [notes and guides](#notes-and-guides)
  - [notes](#notes)
    - [Operator Precedence Table](#operator-precedence-table)
    - [Javascript: Simplified Type Coercion](#javascript-simplified-type-coercion)
      - [1. Operate on incompatible types](#1-operate-on-incompatible-types)
        - [String Coercion](#string-coercion)
        - [Number Coercion](#number-coercion)
        - [Boolean Coercion](#boolean-coercion)
      - [2. Output object or variable](#2-output-object-or-variable)
  - [guides](#guides)

## Built-in operators and directives

### typeof

`typeof` - shows type of variable

```js
let year;
console.log(year);
console.log(typeof year);

// output
undefined
undefined

year = 1991;
console.log(typeof year);

// output
number
```

**js** has a bug with `typeof null`

Actually `null` is `undefined`, but for legacy reasons it is kept as `object`

```js
console.log(typeof null);

// output
object
```

---

### let, const

`let`, `const` are for variable declaration

`let` - variable can be changed later

`const` - variable can't be changed later

> By default use `const`, and use `let` only when you are really sure that you need mutable variable.
>
> Never use `var`, it's like `let` but legacy pre-ES6 and function-scoped. And `let` is block-scoped.

examples

```js
let javascriptIsFun = true;
javascriptIsFun = "YES!"; //change variable type and value

let age = 30;
age = 31; // change variable value

const birthYear = 1991;
// birthYear = 1990; // can't do this

// const job; // can't do this
```

By this way, JS creates a property on the global object, not just variable, so **NEVER** use it to just declare variables

```js
lastName = "Schmedtmann";
console.log(lastName);
```

---

### use strict

`'use strict';`

> The `"use strict"` directive was new in ECMAScript version 5. It is not a statement, but a literal expression, ignored by earlier versions of JavaScript. The purpose of `"use strict"` is to indicate that the code should be executed in "strict mode". With strict mode, you can not, for example, use undeclared variables. All modern browsers support "use strict" except Internet Explorer 9 and lower. You can use strict mode in all your programs. It helps you to write cleaner code, like preventing you from using undeclared variables. `"use strict"` is just a string, so IE 9 will not throw an error even if it does not understand it.

---

### debugger

Use `debugger;` to make a breakpoint in code anywhere.

Or use breakpoints in browser.

---

### Math method

> `Math.random` example

```js
const number = Math.trunc(Math.random() * 20) + 1;
```

- `Math.random` - gives random number between 0 and 1
- `Math.trunc` - gets rid of decimal part

* `* 20` - specifying the range between 0 and 19 or 19.9999... if without Math.trunc

+ `+ 1` - specifying the range between 1 and 20

---

##  Functions

### 1. Function's anatomy

![www.udemy.com_course_the-complete-javascript-course_learn_lecture_22648239](./js.assets/www.udemy.com_course_the-complete-javascript-course_learn_lecture_22648239.png)

### 2. Three ways of writing functions

Three different ways of writing functions, but they all work in a similar way:

- receive **input** data
- **transform** data
- **output** data

#### Function declarations

Can be used before it's declared

```js
function calcAgeDe(birthYear) {
  return 2037 - birthYear;
}
```

#### Function expressions

Function value stored on a varibale

```js
const calcAgeEx = function(birthYear) {
  return 2037 - birthYear;
};
```

#### Arrow functions

Great for a quick one-line functions

Has no `this` keyword

```js
const calcAgeAr = birthYear => 2037 - birthYear;
```

---

## [Document](https://developer.mozilla.org/en-US/docs/Web/API/Document)

### 1. [Elements and properties](https://developer.mozilla.org/en-US/docs/Web/API/Element)

#### [Element: classList property](https://developer.mozilla.org/en-US/docs/Web/API/Element/classList)

Although the `classList` property itself is read-only, you can modify its associated `DOMTokenList` using the [`add()`](https://developer.mozilla.org/en-US/docs/Web/API/DOMTokenList/add), [`remove()`](https://developer.mozilla.org/en-US/docs/Web/API/DOMTokenList/remove), [`replace()`](https://developer.mozilla.org/en-US/docs/Web/API/DOMTokenList/replace), and [`toggle()`](https://developer.mozilla.org/en-US/docs/Web/API/DOMTokenList/toggle) methods.

Example modifying classes in element with class `.player--0`

```js
const player0El = document.querySelector('.player--0');

player0El.classList.add('player--active');
player0El.classList.remove('player--active');
player0El.classList.replace('player--active');

// toggle() works like a switcher. If class present it removes it and vice versa
player0El.classList.toggle('player--active');
```

---

## Notes and guides

### 1. Notes

#### JSdoc and VSCode

Sometimes VSCode won't recognise some elements as HTML elements and won't suggest autocompletion. Use **JSdoc** comments to specify object type

Example: 

```js
/** @type {HTMLElement} */

const openModal = function () {
  modal.classList.remove('hidden');
  
  // or use CSS property, but do it when you have not many styles
  // here there will be no autocompletion without JSdoc /** @type {HTMLElement} */
  // modal.style.display = 'block';
  
  overlay.classList.remove('hidden');
};
```

More info:

- [Jscript element.style dont working in script.js (visual studio code)](https://stackoverflow.com/questions/53794004/jscript-element-style-dont-working-in-script-js-visual-studio-code)
- [What does it means on javascript? " /** @type {HTMLElement} */ "](https://stackoverflow.com/questions/71400456/what-does-it-means-on-javascript-type-htmlelement)

---

#### [Operator Precedence Table](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Operator_precedence#table)

The following table lists operators in order from highest precedence (18) to lowest precedence (1).

Several notes about the table:

1. Not all syntax included here are "operators" in the strict sense. For example, spread `...` and arrow `=>` are typically not regarded as operators. However, we still included them to show how tightly they bind compared to other operators/expressions.
2. The left operand of an exponentiation `**` (precedence 13) cannot be one of the unary operators with precedence 14 without grouping, or there will be a [`SyntaxError`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/SyntaxError). That means, although `-1 ** 2` is technically unambiguous, the language requires you to use `(-1) ** 2` instead.
3. The operands of nullish coalescing `??` (precedence 3) cannot be a logical OR `||` (precedence 3) or logical AND `&&` (precedence 4). That means you have to write `(a ?? b) || c` or `a ?? (b || c)`, instead of `a ?? b || c`.
4. Some operators have certain operands that require expressions narrower than those produced by higher-precedence operators. For example, the right-hand side of member access `.` (precedence 17) must be an identifier instead of a grouped expression. The left-hand side of arrow `=>` (precedence 2) must be an arguments list or a single identifier instead of some random expression.
5. Some operators have certain operands that accept expressions wider than those produced by higher-precedence operators. For example, the bracket-enclosed expression of bracket notation `[ … ]` (precedence 17) can be any expression, even comma (precedence 1) joined ones. These operators act as if that operand is "automatically grouped". In this case we will omit the associativity.

| Precedence                                                   | Operator type                                                | Associativity | Individual operators |
| :----------------------------------------------------------- | :----------------------------------------------------------- | :------------ | :------------------- |
| 18                                                           | [Grouping](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Grouping) | n/a           | `( … )`              |
| 17                                                           | [Member Access](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Property_accessors#dot_notation) | left-to-right | `… . …`              |
| [Optional chaining](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Optional_chaining) | `… ?. …`                                                     |               |                      |
| [Computed Member Access](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Property_accessors#bracket_notation) | n/a                                                          | `… [ … ]`     |                      |
| [`new`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new) (with argument list) | `new … ( … )`                                                |               |                      |
| [Function Call](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Functions) | `… ( … )`                                                    |               |                      |
| 16                                                           | [`new`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new) (without argument list) | n/a           | `new …`              |
| 15                                                           | [Postfix Increment](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators#increment_and_decrement) | n/a           | `… ++`               |
| [Postfix Decrement](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators#increment_and_decrement) | `… --`                                                       |               |                      |
| 14                                                           | [Logical NOT (!)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Logical_NOT) | n/a           | `! …`                |
| [Bitwise NOT (~)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Bitwise_NOT) | `~ …`                                                        |               |                      |
| [Unary plus (+)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Unary_plus) | `+ …`                                                        |               |                      |
| [Unary negation (-)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Unary_negation) | `- …`                                                        |               |                      |
| [Prefix Increment](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators#increment_and_decrement) | `++ …`                                                       |               |                      |
| [Prefix Decrement](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators#increment_and_decrement) | `-- …`                                                       |               |                      |
| [`typeof`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/typeof) | `typeof …`                                                   |               |                      |
| [`void`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/void) | `void …`                                                     |               |                      |
| [`delete`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/delete) | `delete …`                                                   |               |                      |
| [`await`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/await) | `await …`                                                    |               |                      |
| 13                                                           | [Exponentiation (**)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Exponentiation) | right-to-left | `… ** …`             |
| 12                                                           | [Multiplication (*)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Multiplication) | left-to-right | `… * …`              |
| [Division (/)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Division) | `… / …`                                                      |               |                      |
| [Remainder (%)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Remainder) | `… % …`                                                      |               |                      |
| 11                                                           | [Addition (+)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Addition) | left-to-right | `… + …`              |
| [Subtraction (-)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Subtraction) | `… - …`                                                      |               |                      |
| 10                                                           | [Bitwise Left Shift (<<)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Left_shift) | left-to-right | `… << …`             |
| [Bitwise Right Shift (>>)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Right_shift) | `… >> …`                                                     |               |                      |
| [Bitwise Unsigned Right Shift (>>>)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Unsigned_right_shift) | `… >>> …`                                                    |               |                      |
| 9                                                            | [Less Than (<)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Less_than) | left-to-right | `… < …`              |
| [Less Than Or Equal (<=)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Less_than_or_equal) | `… <= …`                                                     |               |                      |
| [Greater Than (>)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Greater_than) | `… > …`                                                      |               |                      |
| [Greater Than Or Equal (>=)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Greater_than_or_equal) | `… >= …`                                                     |               |                      |
| [`in`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/in) | `… in …`                                                     |               |                      |
| [`instanceof`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/instanceof) | `… instanceof …`                                             |               |                      |
| 8                                                            | [Equality (==)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Equality) | left-to-right | `… == …`             |
| [Inequality (!=)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Inequality) | `… != …`                                                     |               |                      |
| [Strict Equality (===)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Strict_equality) | `… === …`                                                    |               |                      |
| [Strict Inequality (!==)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Strict_inequality) | `… !== …`                                                    |               |                      |
| 7                                                            | [Bitwise AND (&)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Bitwise_AND) | left-to-right | `… & …`              |
| 6                                                            | [Bitwise XOR (^)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Bitwise_XOR) | left-to-right | `… ^ …`              |
| 5                                                            | [Bitwise OR (\|)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Bitwise_OR) | left-to-right | `… | …`              |
| 4                                                            | [Logical AND (&&)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Logical_AND) | left-to-right | `… && …`             |
| 3                                                            | [Logical OR (\|\|)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Logical_OR) | left-to-right | `… || …`             |
| [Nullish coalescing operator (??)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Nullish_coalescing) | `… ?? …`                                                     |               |                      |
| 2                                                            | [Assignment](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators#assignment_operators) | right-to-left | `… = …`              |
| `… += …`                                                     |                                                              |               |                      |
| `… -= …`                                                     |                                                              |               |                      |
| `… **= …`                                                    |                                                              |               |                      |
| `… *= …`                                                     |                                                              |               |                      |
| `… /= …`                                                     |                                                              |               |                      |
| `… %= …`                                                     |                                                              |               |                      |
| `… <<= …`                                                    |                                                              |               |                      |
| `… >>= …`                                                    |                                                              |               |                      |
| `… >>>= …`                                                   |                                                              |               |                      |
| `… &= …`                                                     |                                                              |               |                      |
| `… ^= …`                                                     |                                                              |               |                      |
| `… |= …`                                                     |                                                              |               |                      |
| `… &&= …`                                                    |                                                              |               |                      |
| `… ||= …`                                                    |                                                              |               |                      |
| `… ??= …`                                                    |                                                              |               |                      |
| [Conditional (ternary) operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Conditional_operator) | right-to-left (Groups on expressions after `?`)              | `… ? … : …`   |                      |
| [Arrow (=>)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions) | right-to-left                                                | `… => …`      |                      |
| [`yield`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/yield) | n/a                                                          | `yield …`     |                      |
| [`yield*`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/yield*) | `yield* …`                                                   |               |                      |
| [Spread (...)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax) | `... …`                                                      |               |                      |
| 1                                                            | [Comma / Sequence](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comma_operator) | left-to-right | `… , …`              |

---

#### [Javascript: Simplified Type Coercion](https://dev.to/urstrulyvishwak/simplified-type-coercion-in-js-36ge)

**Type Coercion:** Automatic conversion of a value from one data type to another data type is called Type Coercion or implicit type conversion. Javascript engine does this in different scenarios. Let's see where and when this conversion happens and what to remember while coding.

> **Declaimer:** Javascript supports explicit conversion as well and my topic is not that hence I am not covering any of its content though it is closely related.

So here,

`date type` - string, number, boolean, function, and object in Javascript.

> 🧐 Rule: all primitive types conversion happens to: string, number or boolean

Coercion generally means `the practice of persuading someone to do something by using force or threats.` - According to Google. Thanks, Google.

Hence, the `Javascript engine` does the same in converting the value from one type to another without your intervention. Ok. When does this generally happen in Javascript?

Yes. Instead of returning an error, it will do type coercion in the following scenarios:

1. Operate on incompatible types.
2. Output object or variable.

Not to worry if you don't get the above points instantly, I would definitely make you remember forever by end of this article.

Let's start:

##### 1. Operate on incompatible types

###### String Coercion

**Operator +:** By default used for adding numbers. This also does some other work when used with strings i.e. concatenation. That is where coercion comes in to picture.

> 🧐 Rule: If any operand is a string and operated with + then the result is always concatenated and the result is a string.

```js
console.log('str' + 1); // str1
console.log('str' + true); // strtrue
console.log('str' + null); //strnull
console.log('str' + undefined); //strundefined
console.log('str' + NaN); //strNaN
```

###### Number Coercion

Operators /, -, *, %: Division, Subtraction, Multiplication, Modulus in order.

> 🧐 Rule: When you operate string numbers with these operators then result will Number. If one or both operands are non-numeric then result will be NaN

```js
console.log('4' - 2); // 2
console.log('4' % 2); // 0
console.log('4' / 2); // 2
console.log('4' * 2); // 8
console.log('4' - NaN); // NaN
console.log('4' / 'str'); // NaN
console.log('4' / undefined); // NaN
```

**== Equality operator:** Used to compare values irrespective of their types. So,

> 🧐 Rule: == operator coerces to number by default except in case of null. null is always equal to null or undefined.

```js
console.log(1 == 1); // true
console.log(1 == '1'); // true - string 1 ocnverts to number. Hence both are equal.
console.log(1 == true); // true - true converts to number 1.
console.log(true == true); // true - 1 == 1 - true
console.log('true' == true); // false. String true converted to NaN. Hence result is false.
console.log('' == 0); // true

// Number coercion won't happen in case of null.
console.log(null == undefined); // true
console.log(null == null); // true
```

> Best Practice: Always use === instead of ==.

###### Boolean Coercion

Happens with logical operators (||, && and !) and logical context.

```js
// Logical context. if statement evaluates to boolean.
// Here number coerced to true.
if (4) {
    console.log('4 is not boolean');
}
```

```js
// evaluated with coerced values as true && true and returns operand as result.

console.log(2 && 4); // 4
console.log(0 || 5); // 5
console.log(!!2); // true
```

> 🧐 Rule: 0, -0, undefined, null, '', false, NaN are falsy as per Javascript engine any other thing is true.

##### 2. Output object or variable

Javascript can output data in different ways like setting `innerHTML, alert(123), console.log` etc.

> 🧐 Rule: In all the ways, the exposed object or variable is coerced to a string.

We are done. Anything below you can read out of your interest.

---

There are a few things that make coercion looks hard to remember. You don't really need to remember any of the below scenarios.

There are many weird scenarios around different operators that result in different results. Here are the examples.

```js
{}+[]+{}
!! 'false' == !! 'false'
['1'] == 1
new Date() + 0
new Date() - 0
[] + null
'4' * new Array();
'4' / new String();
4 + true
```

> Best Practice: Ignore them 😆.

All of them have answers and nothing returns an error. I didn't provide the answer intentionally.

Let's talk practically,

Did you ever use this type of validation in your code?

If your answer is:

yes - don't do it.

no - don't try to use it.

What if the interviewer asks this question?

Most probably, questions asked in the following way:

1. Asks valid coercion question
2. Common sense related

Say,

`1+2+'str' -> 3 + 'str' -> 3str ->` first two are numbers hence added and as per string coercion second part is concatenated.

`'str'+1+2 - str1 + 2 -> str12` - You might have understood.

Execution happens from left to right.

Even if someone asks some weird scenario, you can say that this won't be legitimate coercion it might give some vague result. I don't think this question won't be a deciding factor for the selection.😃

I would suggest having a look at the table shown on this page:

[type conversion](https://www.w3schools.com/js/js_type_conversion.asp)

whenever possible. It will be useful.

Hope I have cleared confusion around `Type Coercion` in Javascript. Please do comment if I miss any valid coercion examples. I will update the article anytime.

---

### 2. Guides
