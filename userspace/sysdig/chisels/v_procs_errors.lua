--[[
Copyright (C) 2013-2018 Draios Inc dba Sysdig.

This file is part of sysdig.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

--]]

view_info = 
{
	id = "procs_errors",
	name = "Processes Errors",
	description = "This view shows system error counters for processes. Errors are grouped into 4 categories: file I/O, network I/O, memory allocation and 'other'.",
	tips = {
		"If you click 'enter' on a selection in this chart, you will be able to see the specific errors that the process is generating.",
		"Digging into a process by clicking on F6 will let you explore the system calls for that specific process and see the full details about what's causing the errors."
	},
	tags = {"Default", "wsysdig"},
	filter = "evt.type!=switch",
	view_type = "table",
	applies_to = {"", "container.id", "fd.name", "fd.containername", "fd.sport", "fd.sproto", "evt.type", "fd.directory", "fd.containerdirectory", "k8s.pod.id", "k8s.rc.id", "k8s.rs.id", "k8s.svc.id", "k8s.ns.id", "marathon.app.id", "marathon.group.name", "mesos.task.id", "mesos.framework.name"},
	drilldown_target = "errors",
	use_defaults = true,
	columns = 
	{
		{
			name = "NA",
			field = "proc.pid",
			is_key = true
		},
		{
			name = "FILE",
			field = "evt.count.error.file",
			description = "Number of file I/O errors generated by the process during the sample interval. On trace files, this is the total for the whole file.",
			colsize = 8,
			aggregation = "SUM"
		},
		{
			name = "NET",
			field = "evt.count.error.net",
			description = "Number of network I/O errors generated by the process during the sample interval. On trace files, this is the total for the whole file.",
			colsize = 8,
			aggregation = "SUM"
		},
		{
			name = "MEMORY",
			field = "evt.count.error.memory",
			description = "Number of memory allocation/release related errors generated by the process during the sample interval. On trace files, this is the total for the whole file.",
			colsize = 8,
			aggregation = "SUM"
		},
		{
			name = "OTHER",
			field = "evt.count.error.other",
			description = "Number of errors generated by the process that don't fall in any of the previous categories. E.g. signal or event related errors. On trace files, this is the total for the whole file.",
			colsize = 8,
			aggregation = "SUM"
		},
		{
			name = "PID",
			description = "Process PID.",
			field = "proc.pid",
			colsize = 8,
		},
		{
			tags = {"containers"},
			name = "Container",
			field = "container.name",
			description = "Name of the container. What this field contains depends on the containerization technology. For example, for docker this is the content of the 'NAMES' column in 'docker ps'",
			colsize = 20
		},
		{
			name = "Command",
			description = "Full command line of the process.",
			field = "proc.exeline",
			aggregation = "MAX",
			colsize = 0
		}
	},
	actions = 
	{
		{
			hotkey = "9",
			command = "kill -9 %proc.pid",
			description = "kill -9",
			ask_confirmation = true,
			wait_finish = false
		},
		{
			hotkey = "c",
			command = "gcore %proc.pid",
			description = "generate core",
		},
		{
			hotkey = "g",
			command = "gdb -p %proc.pid",
			description = "gdb attach",
			wait_finish = false
		},
		{
			hotkey = "k",
			command = "kill %proc.pid",
			description = "kill",
			ask_confirmation = true,
			wait_finish = false
		},
		{
			hotkey = "l",
			command = "ltrace -p %proc.pid",
			description = "ltrace",
		},
		{
			hotkey = "s",
			command = "gdb -p %proc.pid --batch --quiet -ex \"thread apply all bt full\" -ex \"quit\"",
			description = "print stack",
		},
	},
}
