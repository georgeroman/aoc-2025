import gleam/int
import gleam/list
import gleam/string
import simplifile

pub fn run() {
  let assert Ok(contents) = simplifile.read("inputs/day2.txt")

  let all_ids = string.split(contents, ",")
  |> list.map(fn(raw_range) {
    let assert [low_raw, high_raw, ..] = string.split(raw_range, "-")
    let assert Ok(low) = int.parse(low_raw)
    let assert Ok(high) = int.parse(high_raw)

    list.range(low, high)
  })
  |> list.flatten

  // Part 1
  let sum = list.map(all_ids, fn(id) {
    let raw_id = int.to_string(id)
    let length = string.length(raw_id)
    let left = string.drop_end(raw_id, length / 2)
    let right = string.drop_start(raw_id, length / 2)
    case length % 2 == 0 && left == right {
        True -> id
        False -> 0
    }
  })
  |> list.reduce(fn(a, b) { a + b })
  let _ = echo sum

  // Part 2
  let sum = list.map(all_ids, fn(id) {
    let raw_id = int.to_string(id)
    let length = string.length(raw_id)

    let is_invalid = list.range(1, length / 2)
    |> list.map(fn(curr_size) {
        let all_combinations = string.split(raw_id, "")
        |> list.sized_chunk(curr_size)
        |> list.map(string.join(_, ""))

        let assert [combination_to_match, ..] = all_combinations
        list.length(all_combinations) > 1 && list.all(all_combinations, fn (x) { x == combination_to_match })
    })
    |> list.any(fn(x) { x == True })
    case is_invalid {
        True -> id
        False -> 0
    }
  })
  |> list.reduce(fn(a, b) { a + b })
  echo sum
}
