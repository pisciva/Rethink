// A bounded parser for the MVP's linear expressions. Never evaluates JavaScript.
// Represents ax + b. Supports decimals, fractions, parentheses, implicit multiplication.
export type Linear = { a: number; b: number };
type Fraction = { n: bigint; d: bigint };
type ExactLinear = { a: Fraction; b: Fraction };
const ZERO = BigInt(0), ONE = BigInt(1);
const abs = (n: bigint) => n < ZERO ? -n : n;
function fraction(n: bigint, d = ONE): Fraction {
  if (d === ZERO) throw Error('Division by zero');
  if (d < ZERO) { n = -n; d = -d; }
  let a = abs(n), b = d;
  while (b !== ZERO) { const rest = a % b; a = b; b = rest; }
  return { n: n / a, d: d / a };
}
const addFraction = (a: Fraction, b: Fraction, sign = ONE) => fraction(a.n * b.d + sign * b.n * a.d, a.d * b.d);
const multiply = (a: Fraction, b: Fraction) => fraction(a.n * b.n, a.d * b.d);
const divide = (a: Fraction, b: Fraction) => fraction(a.n * b.d, a.d * b.n);
const scalar = (n: Fraction): ExactLinear => ({ a: fraction(ZERO), b: n });

function parseExactLinear(raw: string): ExactLinear | null {
  if (!raw || raw.length > 160) return null;
  if (/\d\s+\d/.test(raw)) return null; // Do not turn two ambiguous number tokens into one answer.
  const text = raw.toLowerCase().replace(/\s+/g, '').replace(/×|·/g, '*').replace(/÷/g, '/').replace(/−/g, '-').replace(/,/g, '.');
  if (/[^0-9x.+\-*/()]/.test(text)) return null;
  const tokens = text.match(/(?:\d+(?:\.\d*)?|\.\d+)|[x+\-*/()]/g) ?? [];
  if (tokens.join('') !== text || tokens.length > 100) return null;
  let pos = 0;
  const add = (l: ExactLinear, r: ExactLinear, sign = ONE): ExactLinear => ({ a: addFraction(l.a, r.a, sign), b: addFraction(l.b, r.b, sign) });
  function atom(): ExactLinear {
    const t = tokens[pos++];
    if (t === '+' || t === '-') {
      const v = atom(); return t === '-' ? { a: fraction(-v.a.n, v.a.d), b: fraction(-v.b.n, v.b.d) } : v;
    }
    if (t === '(') { const v = sum(); if (tokens[pos++] !== ')') throw Error('Unclosed group'); return v; }
    if (t === 'x') return { a: fraction(ONE), b: fraction(ZERO) };
    if (t && /^(?:\d+(?:\.\d*)?|\.\d+)$/.test(t)) {
      const [whole, decimal = ''] = t.split('.');
      return scalar(fraction(BigInt((whole || '0') + decimal), BigInt(10) ** BigInt(decimal.length)));
    }
    throw Error('Invalid atom');
  }
  function product(): ExactLinear {
    let l = atom();
    while (pos < tokens.length) {
      const t = tokens[pos];
      // Numeric adjacency such as 1.2.3 or x2 is not a supported expression.
      const implicit = t === '(' || t === 'x' || (/^\d|^\./.test(t) && tokens[pos - 1] === ')');
      if (t !== '*' && t !== '/' && !implicit) break;
      if (!implicit) pos++;
      const r = atom();
      if (t === '/') {
        if (r.a.n !== ZERO || r.b.n === ZERO) throw Error('Nonlinear division');
        l = { a: divide(l.a, r.b), b: divide(l.b, r.b) };
      } else {
        if (l.a.n !== ZERO && r.a.n !== ZERO) throw Error('Nonlinear multiplication');
        l = { a: addFraction(multiply(l.a, r.b), multiply(r.a, l.b)), b: multiply(l.b, r.b) };
      }
    }
    return l;
  }
  function sum(): ExactLinear {
    let l = product();
    while (tokens[pos] === '+' || tokens[pos] === '-') { const op = tokens[pos++]; l = add(l, product(), op === '+' ? ONE : -ONE); }
    return l;
  }
  try {
    const v = sum();
    const bounded = (value: Fraction) => abs(value.n) < BigInt('1000000000000') * value.d;
    return pos === tokens.length && bounded(v.a) && bounded(v.b) ? v : null;
  } catch { return null; }
}
export function parseLinear(raw: string): Linear | null {
  const value = parseExactLinear(raw);
  return value ? { a: Number(value.a.n) / Number(value.a.d), b: Number(value.b.n) / Number(value.b.d) } : null;
}
export function equivalent(answer: string, expected: string, kind: 'expression' | 'number'): boolean | null {
  const normalized = kind === 'number' ? answer.trim().replace(/^x\s*=\s*/i, '') : answer;
  const a = parseExactLinear(normalized), b = parseExactLinear(expected);
  if (!a || !b || (kind === 'number' && a.a.n !== ZERO)) return null;
  return a.a.n === b.a.n && a.a.d === b.a.d && a.b.n === b.b.n && a.b.d === b.b.d;
}
