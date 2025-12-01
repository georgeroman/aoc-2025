import gleam/int
import gleam/list
import gleam/string
import simplifile

pub fn run() {
  let assert Ok(contents) = simplifile.read("inputs/day1.txt")
  let lines = string.split(contents, "\n")
    |> list.filter(fn(line) { string.length(line) > 0 })

  // Part 1
  let password = lines
  |> list.fold(#(50, 0), fn(acc, line) {
    let assert Ok(direction) = string.first(line)
    let assert Ok(count) = int.parse(string.drop_start(line, 1))

    let new_dial = case direction {
        "L" -> {
          let assert Ok(result) = int.modulo(acc.0 - count, 100)
          result
        }
        _ -> {
          let assert Ok(result) = int.modulo(acc.0 + count, 100)
          result
        }
    }
    let password_increment = case new_dial {
        0 -> 1
        _ -> 0
    }

    #(new_dial, acc.1 + password_increment)
  })
  echo password.1

  // Part 2
  let password = lines
  |> list.fold(#(50, 0), fn(acc, line) {
    let assert Ok(direction) = string.first(line)
    let assert Ok(count) = int.parse(string.drop_start(line, 1))

    let result = case direction {
        "L" -> {
          let assert Ok(dial_result) = int.modulo(acc.0 - count, 100)
          let assert Ok(rotation_result) = int.divide(acc.0 - count, 100)
          let goes_negative = case acc.0 > 0 && acc.0 - count <= 0 {
            True -> 1
            _ -> 0
          }
          #(dial_result, int.absolute_value(rotation_result) + goes_negative)
        }
        _ -> {
          let assert Ok(dial_result) = int.modulo(acc.0 + count, 100)
          let assert Ok(rotation_result) = int.divide(acc.0 + count, 100)
          #(dial_result, int.absolute_value(rotation_result))
        }
    }

    #(result.0, acc.1 + result.1)
  })
  echo password.1
}
