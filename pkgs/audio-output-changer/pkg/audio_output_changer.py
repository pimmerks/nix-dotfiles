#!/usr/bin/env python
import subprocess

# function to parse output of command "wpctl status" and return a dictionary of sinks with their id and name.
def parse_wpctl_status():
    # Execute the wpctl status command and store the output in a variable.
    output = str(subprocess.check_output("wpctl status", shell=True, encoding='utf-8'))

    # remove the ascii tree characters and return a list of lines
    lines = output.replace("├", "").replace("─", "").replace("│", "").replace("└", "").splitlines()

    # get the index of the Sinks line as a starting point
    sinks_index = None
    for index, line in enumerate(lines):
        if "Sinks:" in line:
            sinks_index = index
            break

    # start by getting the lines after "Sinks:" and before the next blank line and store them in a list
    sinks = []
    for line in lines[sinks_index +1:]:
        if not line.strip():
            break
        sinks.append(line.strip())

    # remove the "[vol:" from the end of the sink name
    for index, sink in enumerate(sinks):
        sinks[index] = sink.split("[vol:")[0].strip()

    sinks_dict = []

    # strip the * from the default sink and instead append "- Default" to the end. Looks neater in the wofi list this way.
    for index, sink in enumerate(sinks):
        stripped = sink.strip().replace("*", "").strip()
        sinks_dict.append(
            {
                "sink_id": int(stripped.split(".")[0]),
                "sink_name": stripped.split(".")[1].strip(),
                "default": sink.startswith("*")
            }
        )

    return sinks_dict

def main():
  # get the list of sinks ready to put into wofi - highlight the current default sink
  output = ''
  sinks = parse_wpctl_status()
  current_output_index = -1

  for i, items in enumerate(sinks):
      if items['default']:
          output += f"<b>-> {items['sink_name']}</b>\n"
          current_output_index = i
      else:
          output += f"{items['sink_name']}\n"

  output = output.removesuffix("\n")

  rofi_command = f"echo '{output}' | rofi -dmenu -markup-rows -p \"Select audio output\" -a {current_output_index} -format p"
  rofi_process = subprocess.run(rofi_command, shell=True, encoding='utf-8', stdout=subprocess.PIPE, stderr=subprocess.PIPE)

  if rofi_process.returncode != 0:
      print("User cancelled the operation.")
      exit(0)

  selected_sink_name = rofi_process.stdout.strip().removeprefix('-> ')

  sinks = parse_wpctl_status()
  selected_sink = next(sink for sink in sinks if sink['sink_name'] == selected_sink_name)

  subprocess.run(f"wpctl set-default {selected_sink['sink_id']}", shell=True)

if __name__ == '__main__':
  main()
