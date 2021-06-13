import chalk from 'chalk';
import glob from 'glob';
import { exec } from './exec';
import { logger } from './logger';
import { createParameter as _createParameter } from './parameter';
import { RunnerConfig } from './runner';
import { createTarget as _createTarget } from './target';
export { exec, chalk, glob, logger };
export declare const setup: (config?: RunnerConfig) => void;
export declare const createTarget: typeof _createTarget;
export declare const createParameter: typeof _createParameter;
export declare const sleep: (time: number) => Promise<unknown>;
/**
 * Resolves a glob pattern and returns files that are safe
 * to call `stat` on.
 */
export declare const resolveGlob: (globPath: string) => string[];
