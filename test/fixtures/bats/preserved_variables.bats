@test "run sets variables from run" {
  odd_characters="'(')'"'!@#$$%^&*~`{}[]:;"<>,./\\'
  normal_var=1
  
  change_vars() {
    normal_var=3
    new_var=4
    new_array=()
    new_array[0]="  item  with  spaces  "
    new_array[3]="item after gap"
    new_array[4]="$odd_characters"
  }
  
  run -v normal_var -v new_var -v new_array change_vars

  [ "$normal_var" -eq 3 ]
  [ "$new_var" -eq 4 ]
  [ "${new_array[0]}" == "  item  with  spaces  " ]
  [ "${new_array[3]}" == "item after gap" ]
  [ "${new_array[4]}" == "$odd_characters" ]
}

@test "run handles readonly variables" {
  readonly readonly_var=2
  
  change_vars() {
    :
  }

  run -v readonly_var change_vars

  [ "$readonly_var" -eq 2 ]
}

@test "local variables are not available after run" {
  change_vars() {
    local local_var=1
    global_var=2
  }

  run -v local_var -v global_var change_vars

  [ -z "$local_var" ]
  [ "$global_var" -eq 2 ]
}

@test "run accepts multiple variables" {
  change_vars() {
    var1=1
    var2=2
    var3=3
  }

  run -v var1 -v var2 -v var3 change_vars

  [ "$var1" -eq 1 ]
  [ "$var2" -eq 2 ]
  [ "$var3" -eq 3 ]
}

@test "double dash terminates run variable list" {
  -v() {
    param_var="$1"
    normal_var=1
  }

  run -v param_var -v normal_var -- -v param_value

  [ "$param_var" == "param_value" ]
  [ "$normal_var" -eq 1 ]
}
