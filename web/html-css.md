---
title: html-css
categories:
  - software
  - guides
  - notes
  - code
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [Flexbox](#flexbox)
  - [Flexbox properties](#flexbox-properties)
    - [Flexbox main properties](#flexbox-main-properties)

## Flexbox

### Flexbox properties

`flex` property defaults

```css
flex-grow: 0; /* To allow an element to grow (0 means no, 1+ means yes) */
flex-shrink: 1; /* To allow an element to shrink (0 means no, 1+ means yes) */
flex-basis: auto; /* To define an item’s width, instead of the width property */
```

`flex: 1;` means:

```css
flex-grow: 1; /* The div will grow in same proportion as the window-size */
flex-shrink: 1; /* The div will shrink in same proportion as the window-size */
flex-basis: 0; /* The div does not have a starting value as such and will take up screen as per the screen size available for e.g:- if 3 divs are in the wrapper then each div will take 33%. */
```

#### Flexbox main properties

- Flexbox is a set of related **CSSproperties** for **building 1-dimensional layouts**
- The main idea behind flexbox is that empty space inside a container element can be **automatically divided** by its child elements
- Flexbox makes it easy to automatically **align items to one another** inside a parent container, both horizontally and vertically
- Flexbox solves common problems such as **vertical centering** and creating **equal-height columns**
- Flexbox is perfect for **replacing floats**, allowing us to write fewer and cleaner HTML and CSS code

![flexbox](./html-css.assets/SCR-20230920-pvsz.png)

| FLEX CONTAINER |
| :------------: |

| #    | Name             | Default value | Values                                                       | Description                                                  | Notes            |
| ---- | ---------------- | ------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ---------------- |
| 1    | gap:             | 0             | `lenth`                                                      | To create **space between items***, without using margin     |                  |
| 2    | justify-content: | flex-start    | flex-end / center / space-between / space-around / space-evenly | To align items along main axis (**horizontally**, by default) |                  |
| 3    | align-items:     | stretch       | flex-start / flex-end / center / baseline                    | To align items along cross axis (**vertically**, by default) |                  |
| 4    | flex-direction:  | row           | row-reverse / column / column-reverse                        | To define which is the **main axis**                         |                  |
| 5    | flex-wrap:       | nowrap        | wrap / wrap-reverse                                          | To allow items to **wrap into a new line** if they are too large | Advanced feature |
| 6    | align-content:   | stretch       | flex-start / flex-end / center / space-between / space-around | Only applies when there are **multiple lines** (flex-wrap: wrap) | Advanced feature |

| FLEX ITEMS |
| :--------: |

| #    | Name         | Default value | Values                                               | Description                                                  | Notes |
| ---- | ------------ | ------------- | ---------------------------------------------------- | ------------------------------------------------------------ | ----- |
| 1    | align-self:  | auto          | stretch / flex-start / flex- end / center / baseline | To **overwrite** align-items for individual flex items       |       |
| 2    | flex-grow:   | 0             | `integer`                                            | To allow an element **to grow** (0 means no, 1+ means yes)   |       |
| 3    | flex-shrink: | 1             | `integer`                                            | To allow an element **to shrink** (0 means no, 1+ means yes) |       |
| 4    | flex-basis:  | auto          | `length`                                             | To define an item’s width, **instead of the width** property |       |
| 5    | flex:        | 0 1 auto      | `integer` `integer` `lenth`                          | **Recommended** shorthand for flex-grow, -shrink, -basis.    |       |
| 6    | order:       | 0             | `integer`                                            | Controls order of items. -1 makes item **first**, 1 makes it **last** |       |
