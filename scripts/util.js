class Util {
  static processStdin() {
    return new Promise((resolve, reject) => {
      let input = '';
      process.stdin.on('readable', () => {
        const chunk = process.stdin.read();
        if (chunk !== null) {
          input += chunk;
        }
      });
      process.stdin.on('end', () => {
        if (input.length === 0) {
          return reject('STDIN input is required');
        }
        resolve(input);
      });
    });
  }

  static out(object) {
    console.log(JSON.stringify(object));
  }
}

module.exports = Util;
