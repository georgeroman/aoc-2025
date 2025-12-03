import gleam/int
import gleam/list
import gleam/string
import simplifile

fn recurse (cs: String, n: Int) {
    let search_list = string.drop_end(cs, n)
    |> string.split("")
    |> list.map(fn(c) {
        let assert Ok(n) = int.parse(c)
        n
    })

    let max = search_list
    |> list.fold(0, fn(acc, x) {
        case x > acc {
            True -> x
            False -> acc
        }
    })

    let assert Ok(result) = list.zip(search_list, list.range(0, string.length(cs) - n))
    |> list.find(fn (x) { x.0 == max })

    case n > 0 {
        True -> int.to_string(max) <> recurse(string.drop_start(cs, result.1 + 1), n - 1)
        False -> int.to_string(max)
    }
}

pub fn run() {
  let assert Ok(contents) = simplifile.read("inputs/day3.txt")
  let lines = string.split(contents, "\n")
    |> list.filter(fn(line) { string.length(line) > 0 })

  let max_in_list = fn(a: Int, b: Int) {
    case a >= b {
        True -> a
        False -> b
    }
  }

  // Part 1
  let assert Ok(sum) = list.map(lines, fn(line) {
    let line_length = string.length(line)
    list.range(0, line_length - 1)
    |> list.map(fn (i) {
        let first = string.slice(line, i, 1)
        string.slice(line, i + 1, line_length)
        |> string.split("")
        |> list.map(fn(c) {
            let assert Ok(n) = int.parse(first <> c)
            n
        })
        |> list.fold(0, max_in_list)
    })
    |> list.fold(0, max_in_list)
  })
  |> list.reduce(fn(a, b) { a + b })
  echo sum

  // Part 2
  let assert Ok(sum) = list.map(lines, fn(line) {
    let assert Ok(max) = int.parse(recurse(line, 11))
    max
  })
  |> list.reduce(fn(a, b) { a + b })
  echo sum
}
