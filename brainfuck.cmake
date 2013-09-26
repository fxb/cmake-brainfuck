#    ____
#   |  _ \ _ __ ___   __ _ _ __ __ _ _ __ ___  ___
#   | |_) | '__/ _ \ / _` | '__/ _` | '_ ` _ \/ __|
#   |  __/| | | (_) | (_| | | | (_| | | | | | \__ \
#   |_|   |_|  \___/ \__, |_|  \__,_|_| |_| |_|___/
#                    |___/

# Hello World!
set(PROGRAM_STRING "++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.,")

# cat
#set(PROGRAM_STRING ",[.,]")
#set(PROGRAM_STRING ",+[-.,+]")
#set(PROGRAM_STRING ",[.[-],]")

# Squares
#set(PROGRAM_STRING "++++[>+++++<-]>[<+++++>-]+<+[>[>+>+<<-]++>>[<<+>>-]>>>[-]++>[-]+>>>+[[-]++++++>>>]<<<[[<++++++++<++>>-]+<.<[>----<-]<]<<[>>>>>[>>>[-]+++++++++<[>-<-]+++++++++>[-[<->-]+[<<<]]<[>+<-]>]<<-]<<-]")

#    ___    _____
#   |_ _|  / / _ \
#    | |  / / | | |
#    | | / /| |_| |
#   |___/_/  \___/

set(INPUT_STRING "fxb")
set(OUTPUT_STRING "")

macro(getchar OUTPUT_VARIABLE)
  string(SUBSTRING "${INPUT_STRING}" 0 1 CHAR)
  string(SUBSTRING "${INPUT_STRING}" 1 -1 INPUT_STRING)
  ord("${CHAR}" ${OUTPUT_VARIABLE})
endmacro()

macro(putchar VALUE)
  string(ASCII ${VALUE} CHAR)
  set(OUTPUT_STRING "${OUTPUT_STRING}${CHAR}")
endmacro()

#    __  __
#   |  \/  | ___ _ __ ___   ___  _ __ _   _
#   | |\/| |/ _ \ '_ ` _ \ / _ \| '__| | | |
#   | |  | |  __/ | | | | | (_) | |  | |_| |
#   |_|  |_|\___|_| |_| |_|\___/|_|   \__, |
#                                     |___/

set(MEMORY_LIST "")
set(MEMORY_SIZE 0)
set(MEMORY_POINTER 0)

macro(memory_grow SIZE)
  while(${MEMORY_SIZE} LESS ${SIZE})
    list(APPEND MEMORY_LIST 0)
    list(LENGTH MEMORY_LIST MEMORY_SIZE)
  endwhile()
endmacro()

macro(memory_load INDEX OUTPUT_VARIABLE)
  math(EXPR SIZE "${INDEX} + 1")
  memory_grow(${SIZE})
  list(GET MEMORY_LIST ${INDEX} ${OUTPUT_VARIABLE})
endmacro()

macro(memory_store INDEX VALUE)
  math(EXPR SIZE "${INDEX} + 1")
  memory_grow(${SIZE})
  list(INSERT MEMORY_LIST ${INDEX} ${VALUE})
  list(REMOVE_AT MEMORY_LIST ${SIZE})
endmacro()

#       _    ____   ____ ___ ___
#      / \  / ___| / ___|_ _|_ _|
#     / _ \ \___ \| |    | | | |
#    / ___ \ ___) | |___ | | | |
#   /_/   \_\____/ \____|___|___|

macro(ord CHAR OUTPUT_VARIABLE)
  foreach(INDEX RANGE 1 255)
    string(ASCII ${INDEX} CHAR_TMP)

    # Surround characters in "#" to avoid "mismatched parenthesis in condition" cmake bug.
    if("#${CHAR}#" STREQUAL "#${CHAR_TMP}#")
      set(${OUTPUT_VARIABLE} "${INDEX}")
    endif()
  endforeach()
endmacro()

#    ___       _                           _
#   |_ _|_ __ | |_ ___ _ __ _ __  _ __ ___| |_ ___ _ __
#    | || '_ \| __/ _ \ '__| '_ \| '__/ _ \ __/ _ \ '__|
#    | || | | | ||  __/ |  | |_) | | |  __/ ||  __/ |
#   |___|_| |_|\__\___|_|  | .__/|_|  \___|\__\___|_|
#                          |_|

set(PROGRAM_COUNTER 0)
string(LENGTH "${PROGRAM_STRING}" PROGRAM_SIZE)

while(${PROGRAM_COUNTER} LESS ${PROGRAM_SIZE})
  string(SUBSTRING "${PROGRAM_STRING}" ${PROGRAM_COUNTER} 1 INSTRUCTION)

  # Increment data pointer
  if("${INSTRUCTION}" STREQUAL ">")
    math(EXPR MEMORY_POINTER "${MEMORY_POINTER} + 1")
  # Decrement data pointer
  elseif("${INSTRUCTION}" STREQUAL "<")
    math(EXPR MEMORY_POINTER "${MEMORY_POINTER} - 1")
  # Increment value at data pointer
  elseif("${INSTRUCTION}" STREQUAL "+")
    memory_load(${MEMORY_POINTER} VALUE)
    math(EXPR VALUE "${VALUE} + 1")
    memory_store(${MEMORY_POINTER} ${VALUE})
  # Decrement value at data pointer
  elseif("${INSTRUCTION}" STREQUAL "-")
    memory_load(${MEMORY_POINTER} VALUE)
    math(EXPR VALUE "${VALUE} - 1")
    memory_store(${MEMORY_POINTER} ${VALUE})
  # Output value at data pointer
  elseif("${INSTRUCTION}" STREQUAL ".")
    memory_load(${MEMORY_POINTER} VALUE)
    putchar(${VALUE})
  # Accept input value and store it at data pointer
  elseif("${INSTRUCTION}" STREQUAL ",")
    string(LENGTH "${INPUT_STRING}" INPUT_SIZE)
    if(${INPUT_SIZE} EQUAL 0)
      break()
    endif()
    getchar(VALUE)
    memory_store(${MEMORY_POINTER} ${VALUE})
  elseif("${INSTRUCTION}" STREQUAL "[")
    memory_load(${MEMORY_POINTER} VALUE)
    if(${VALUE} EQUAL 0)
      set(N 1)
      while(${N} GREATER 0)
        math(EXPR PROGRAM_COUNTER "${PROGRAM_COUNTER} + 1")
        string(SUBSTRING "${PROGRAM_STRING}" ${PROGRAM_COUNTER} 1 INSTRUCTION)

        if("${INSTRUCTION}" STREQUAL "[")
          math(EXPR N "${N} + 1")
        elseif("${INSTRUCTION}" STREQUAL "]")
          math(EXPR N "${N} - 1")
        endif()
      endwhile()
    endif()
  elseif("${INSTRUCTION}" STREQUAL "]")
    memory_load(${MEMORY_POINTER} VALUE)
    if(NOT ${VALUE} EQUAL 0)
      set(N 1)
      while(${N} GREATER 0)
        math(EXPR PROGRAM_COUNTER "${PROGRAM_COUNTER} - 1")
        string(SUBSTRING "${PROGRAM_STRING}" ${PROGRAM_COUNTER} 1 INSTRUCTION)

        if("${INSTRUCTION}" STREQUAL "]")
          math(EXPR N "${N} + 1")
        elseif("${INSTRUCTION}" STREQUAL "[")
          math(EXPR N "${N} - 1")
        endif()
      endwhile()
    endif()
  endif()

  math(EXPR PROGRAM_COUNTER "${PROGRAM_COUNTER} + 1")
endwhile()

#    ____                    _  _
#   |  _ \  ___  ___  _   _ | || |_
#   | |_) |/ _ \/ __|| | | || || __|
#   |  _ <|  __/\__ \| |_| || || |_
#   |_| \_\\___||___/ \__,_||_| \__|

message("${OUTPUT_STRING}")
