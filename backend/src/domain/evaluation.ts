import { equivalent } from './mathematics.ts';
import { questions } from '../content/distribution.ts';
import { explanationObservation } from './diagnosis.ts';
import type { Observation } from './model.ts';

/** LC-03 produces item observations; C3 and C5 own their distinct conclusions. */
export function evaluateAnswer(key: keyof typeof questions, raw: string): Observation | null {
  const question = questions[key];
  const answer = raw.trim();
  if (!answer || answer.length > (key === 'q3' ? 1200 : 160)) return null;
  if (question.format === 'explanation') return explanationObservation(answer);
  if (question.format === 'choice') {
    if (!question.options?.some(option => option.id === answer)) return null;
    return answer === question.expected ? 'correct' : answer === question.knownError ? 'known-error' : 'incorrect';
  }
  if (question.format === 'expression' && /[()]/.test(answer)) return null; // Draft task asks for expanded form.
  const correct = equivalent(answer, question.expected!, question.format);
  if (correct === null) return null;
  if (correct) return 'correct';
  return question.knownError && equivalent(answer, question.knownError, question.format) === true ? 'known-error' : 'incorrect';
}

