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
  - [guides](#guides)

## built-in operators

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

## notes and guides

### notes

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

### guides
