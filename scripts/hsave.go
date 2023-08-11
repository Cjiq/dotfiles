package main

import (
	"fmt" 
	"os/exec"
	"os"
	"log"
	"strconv"
	"strings"
	"flag"
)

type context struct {
	s bool
}

var con *context = &context{}

func main() {
	shell := getShellName()
	home,_ := os.UserHomeDir()
	histPath := fmt.Sprintf("%s/.%s_history", home, shell)
	lines := lastTenLines(histPath)
	lastHist := lines[len(lines)-1]
	splits := strings.Split(lastHist, ";")
	lastCMD := splits[len(splits)-1]
	hsaveDB := home + "/.hsave_db"
	writeLine(hsaveDB, lastCMD)
	fmt.Printf("Saved cmd: '%s' in %s\n", lastCMD, hsaveDB)
}

func writeLine(filename string, line string) {
	f, err := os.OpenFile(filename, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()
	if _, err := f.WriteString(line + "\n"); err != nil {
		log.Fatal(err)
	}
}

func lastTenLines(path string) []string {
	out := runCmd("/bin/tail", "-n", "25", path)
	lines := strings.Split(out, "\n")
	filteredLines := []string{}
	for _, line := range lines {
		if strings.Contains(line, "hsave") {
			continue;
		}
		filteredLines = append(filteredLines, line)
	}
	return filteredLines
}

func getShellName() string {
	parentPID := runCmd("/bin/ps", "-o", "ppid=", "-p", strconv.Itoa(os.Getppid()))
	out := runCmd("/bin/ps", "-p", parentPID)
	splits := strings.Split(out, "\n")
	splits =  strings.Split(splits[len(splits)-1], " ") 
	return splits[len(splits)-1]
}

func runCmd(args ...string) string {
	cmd := exec.Command(args[0], args[1:]...)
	cmd.Env = os.Environ()
	out, err := cmd.Output()
	if err != nil {
		log.Fatal(err)
	}
	return strings.Trim(string(out), "\n \t \r")
}